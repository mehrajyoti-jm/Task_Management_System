import React, { useEffect, useState } from "react";
import api from "../api/axios";
import { useAuth } from "../context/AuthContext";

function Dashboard() {
  const { user } = useAuth();
  const [summary, setSummary] = useState({ toDo: 0, inProgress: 0, done: 0 });
  const [notifications, setNotifications] = useState([]);

  useEffect(() => {
    loadSummary();
    loadNotifications();
  }, []);

  const loadSummary = async () => {
    try {
      const res = await api.get("/tasks/dashboard-summary");
      setSummary({
        toDo: res.data.toDo,
        inProgress: res.data.inProgress,
        done: res.data.done,
      });
    } catch (err) {
      console.error("Failed to load dashboard summary", err);
    }
  };

  const loadNotifications = async () => {
    try {
      const res = await api.get("/notifications");
      setNotifications(res.data);
    } catch (err) {
      console.error("Failed to load notifications", err);
    }
  };

  return (
    <div className="container">
      <h2>Welcome, {user?.fullName}</h2>

      <div className="summary-row">
        <div className="summary-box">
          <h2>{summary.toDo}</h2>
          <p>To Do</p>
        </div>
        <div className="summary-box">
          <h2>{summary.inProgress}</h2>
          <p>In Progress</p>
        </div>
        <div className="summary-box">
          <h2>{summary.done}</h2>
          <p>Done</p>
        </div>
      </div>

      <div className="card">
        <h3>Recent Notifications</h3>
        {notifications.length === 0 && <p>No notifications yet.</p>}
        {notifications.slice(0, 5).map((n) => (
          <div key={n.id} className="comment">
            {n.message}
            <div style={{ fontSize: 12, color: "#888" }}>
              {new Date(n.createdAt).toLocaleString()}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

export default Dashboard;
