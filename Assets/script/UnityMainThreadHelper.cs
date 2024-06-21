using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UnityMainThreadHelper : MonoBehaviour
{
    private readonly Queue<Action> _jobs = new Queue<Action>();
    private static readonly object _lock = new object();

    private void Update()
    {
        lock (_lock)
        {
            while (_jobs.Count > 0)
            {
                _jobs.Dequeue()?.Invoke();
            }
        }
    }

    public void AddJob(Action job)
    {
        lock (_lock)
        {
            _jobs.Enqueue(job);
        }
    }
}