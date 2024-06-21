using System;
using System.Collections;
using UnityEngine;
using UnityEngine.Networking;
using WebSocketSharp;

public class WebSocketController : MonoBehaviour
{
    private WebSocket websocket;
    private int id1;
    private int id2;
    private Vector3 startPoint;
    private Vector3 endPoint;
    private LineRenderer lineRenderer;
    private bool isAnimating = false;
    private UnityMainThreadHelper mainThreadHelper;

    public float animationDuration = 2f;
    public Camera mainCamera;

    private void Start()
    {
        lineRenderer = gameObject.GetComponent<LineRenderer>();
        mainThreadHelper = gameObject.AddComponent<UnityMainThreadHelper>();
        ConnectWebSocket();
    }

    private void Update()
    {
        // カメラの位置にstartPointを追従させる
        if (mainCamera != null)
        {
            Vector3 cameraPosition = mainCamera.transform.position;
            startPoint = new Vector3(cameraPosition.x, 0f, cameraPosition.z);
        }
    }

    private void ConnectWebSocket()
    {
        websocket = new WebSocket("wss://mr-mapping-ws-3f76a2e253dd.herokuapp.com/ws");

        websocket.OnOpen += (sender, e) =>
        {
            Debug.Log("WebSocket connection established.");
        };

        websocket.OnClose += (sender, e) =>
        {
            Debug.Log("WebSocket connection closed.");
        };

        websocket.OnMessage += OnWebSocketMessage;

        websocket.OnError += (sender, e) =>
        {
            Debug.Log("WebSocket error: " + e.Message);
        };

        websocket.Connect();
    }

    private void OnWebSocketMessage(object sender, MessageEventArgs e)
    {
        var message = e.Data;
        Debug.Log("Received message: " + message);

        try
        {
            mainThreadHelper.AddJob(() => StartCoroutine(ProcessMessage(message)));
        }
        catch (Exception ex)
        {
            Debug.LogError("Error processing message: " + ex.Message);
        }
    }

    private IEnumerator ProcessMessage(string message)
    {
        string id1Value = "";
        string id2Value = "";

        try
        {
            id1Value = ExtractIdValue(message, "id1");
            id2Value = ExtractIdValue(message, "id2");

            Debug.Log(id1Value);
            Debug.Log(id2Value);

            id1 = int.Parse(id1Value);
            id2 = int.Parse(id2Value);

            Debug.Log("Extracted IDs - id1: " + id1 + ", id2: " + id2);
        }
        catch (Exception ex)
        {
            Debug.LogError("Error parsing message: " + ex.Message);
            yield break;
        }

        yield return FetchRoomDataCoroutine((room1, room2) =>
        {
            if (room1 != null && room2 != null)
            {
                startPoint = new Vector3(room1.X, 0f, room1.Y);
                endPoint = new Vector3(room2.X, 0f, room2.Y);

                StartCoroutine(AnimateLine());
            }
        });
    }


    private IEnumerator FetchRoomDataCoroutine(Action<Room, Room> callback)
    {
        Room room1 = null;
        Room room2 = null;

        // Fetch room data for id1
        string url1 = $"https://mr-mapping-0803eb6691db.herokuapp.com/rooms/{id1}";
        using (UnityWebRequest www1 = UnityWebRequest.Get(url1))
        {
            yield return www1.SendWebRequest();

            if (www1.result == UnityWebRequest.Result.ConnectionError || www1.result == UnityWebRequest.Result.ProtocolError)
            {
                Debug.Log("Error fetching room data for id1: " + www1.error);
            }
            else
            {
                Debug.Log("Response status code for id1: " + www1.responseCode);
                string json1 = www1.downloadHandler.text;
                Debug.Log("Room data for id1: " + json1);

                try
                {
                    room1 = JsonUtility.FromJson<Room>(json1);
                    room1.X = int.Parse(ExtractIdValue(json1, "x"));
                    room1.Y = int.Parse(ExtractIdValue(json1, "y"));
                }
                catch (Exception ex)
                {
                    Debug.LogError("Error deserializing room data for id1: " + ex.Message);
                }
            }
        }

        // Fetch room data for id2
        string url2 = $"https://mr-mapping-0803eb6691db.herokuapp.com/rooms/{id2}";
        using (UnityWebRequest www2 = UnityWebRequest.Get(url2))
        {
            yield return www2.SendWebRequest();

            if (www2.result == UnityWebRequest.Result.ConnectionError || www2.result == UnityWebRequest.Result.ProtocolError)
            {
                Debug.Log("Error fetching room data for id2: " + www2.error);
            }
            else
            {
                Debug.Log("Response status code for id2: " + www2.responseCode);
                string json2 = www2.downloadHandler.text;
                Debug.Log("Room data for id2: " + json2);

                try
                {
                    room2 = JsonUtility.FromJson<Room>(json2);
                    room2.X = int.Parse(ExtractIdValue(json2, "x"));
                    room2.Y = int.Parse(ExtractIdValue(json2, "y"));
                }
                catch (Exception ex)
                {
                    Debug.LogError("Error deserializing room data for id2: " + ex.Message);
                }
            }
        }

        callback(room1, room2);
    }

    private IEnumerator AnimateLine()
    {
        if (lineRenderer == null)
        {
            Debug.LogError("LineRenderer component is missing!");
            yield break;
        }

        if (isAnimating)
        {
            yield break;
        }

        isAnimating = true;

        float startTime = Time.time;

        Vector3[] positions = new Vector3[2];
        positions[0] = startPoint;

        while (Time.time - startTime < animationDuration)
        {
            float t = (Time.time - startTime) / animationDuration;
            positions[1] = Vector3.Lerp(startPoint, endPoint, t);
            lineRenderer.SetPositions(positions);
            yield return null;
        }

        positions[1] = endPoint;
        lineRenderer.SetPositions(positions);

        lineRenderer.startWidth = 1.0f;
        lineRenderer.endWidth = 1.0f;

        Debug.Log($"Line drawn from {positions[0]} to {positions[1]}");

        isAnimating = false;
    }

    private void OnApplicationQuit()
    {
        lineRenderer.SetPositions(new Vector3[2]);
        websocket.Close();
    }

    private String ExtractIdValue(string message, string idKey)
    {
        int idStartIndex = message.IndexOf(idKey) + idKey.Length + 1;

        for (int i = idStartIndex; i < message.Length; i++)
        {
            if (char.IsDigit(message[i]))
            {
                int idEndIndex = i + 1;
                while (idEndIndex < message.Length && char.IsDigit(message[idEndIndex]))
                {
                    idEndIndex++;
                }

                string idValue = message.Substring(i, idEndIndex - i);
                return idValue;
            }
        }

        throw new FormatException("Invalid message format. ID value not found.");
    }
}

[Serializable]
public class Room
{
    public int id;
    public string name;
    public int X;
    public int Y;
}