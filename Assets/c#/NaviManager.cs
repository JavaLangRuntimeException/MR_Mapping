using System.Collections;
using UnityEngine;
using UnityEngine.Networking;

public class NaviManager : MonoBehaviour
{
    public Material lineMaterial;
    public Color lineColor = Color.white;
    public float lineWidth = 0.1f;

    private void Start()
    {
        StartCoroutine(GetNaviData(navis =>
        {
            if (navis != null)
            {
                foreach (Navi navi in navis)
                {
                    DrawLine(navi);
                }
            }
        }));
    }

    private IEnumerator GetNaviData(System.Action<Navi[]> callback)
    {
        string url = "https://mr-mapping-88ceb7c2955d.herokuapp.com/navis/";
        using (UnityWebRequest request = UnityWebRequest.Get(url))
        {
            yield return request.SendWebRequest();

            if (request.result == UnityWebRequest.Result.Success)
            {
                string json = request.downloadHandler.text;
                Navi[] navis = JsonUtility.FromJson<Navi[]>(json);
                callback(navis);
            }
            else
            {
                Debug.LogError("API request failed: " + request.error);
                callback(null);
            }
        }
    }

    private void DrawLine(Navi navi)
    {
        Vector3 startPos = new Vector3(navi.dep_room.x, 0f, navi.dep_room.y);
        Vector3 endPos = new Vector3(navi.arr_room.x, 0f, navi.arr_room.y);

        LineRenderer lineRenderer = gameObject.AddComponent<LineRenderer>();
        lineRenderer.positionCount = 2;
        lineRenderer.SetPosition(0, startPos);
        lineRenderer.SetPosition(1, endPos);

        // 実線のマテリアルと色を設定
        lineRenderer.material = lineMaterial;
        lineRenderer.startColor = lineColor;
        lineRenderer.endColor = lineColor;

        // 実線の幅を設定
        lineRenderer.startWidth = lineWidth;
        lineRenderer.endWidth = lineWidth;
    }
}
