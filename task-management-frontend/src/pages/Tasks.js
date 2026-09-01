import React, { useEffect, useState } from "react";
import api from "../api/axios";
import { useAuth } from "../context/AuthContext";
import CommentSection from "../components/CommentSection";

function statusBadgeClass(status) {
  if (status === "To Do") return "badge badge-todo";
  if (status === "In Progress") return "badge badge-inprogress";
  return "badge badge-done";
}

function Tasks() {
  const { user } = useAuth();
  const canCreateTasks = user?.role === "Admin" || user?.role === "Manager";

  const [tasks, setTasks] = useState([]);
  const [users, setUsers] = useState([]);
  const [expandedTaskId, setExpandedTaskId] = useState(null);

  // Filters (Dashboard requirement: filter by status, priority, deadline)
  const [statusFilter, setStatusFilter] = useState("");
  const [priorityFilter, setPriorityFilter] = useState("");
  const [deadlineFilter, setDeadlineFilter] = useState("");

  // New task form fields
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [priority, setPriority] = useState("Medium");
  const [deadline, setDeadline] = useState("");
  const [assignedToId, setAssignedToId] = useState("");
  const [formError, setFormError] = useState("");

  useEffect(() => {
    loadTasks();
    if (canCreateTasks) loadUsers();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [statusFilter, priorityFilter, deadlineFilter]);

  const loadTasks = async () => {
    try {
      const params = {};
      if (statusFilter) params.status = statusFilter;
      if (priorityFilter) params.priority = priorityFilter;
      if (deadlineFilter) params.deadline = deadlineFilter;

      const res = await api.get("/tasks", { params });
      setTasks(res.data);
    } catch (err) {
      console.error("Failed to load tasks", err);
    }
  };

  const loadUsers = async () => {
    try {
      const res = await api.get("/teams/users");
      setUsers(res.data);
    } catch (err) {
      console.error("Failed to load users", err);
    }
  };

  const handleCreateTask = async (e) => {
    e.preventDefault();
    setFormError("");

    if (!assignedToId) {
      setFormError("Please choose a user to assign this task to.");
      return;
    }

    try {
      await api.post("/Tasks", {
        title,
        description,
        priority,
        deadline: deadline || null,
        assignedToId: parseInt(assignedToId, 10),
      });

      // Reset the form
      setTitle("");
      setDescription("");
      setPriority("Medium");
      setDeadline("");
      setAssignedToId("");

      loadTasks();
    } catch (err) {
      setFormError(err.response?.data?.message || "Failed to create task.");
    }
  };

  const handleStatusChange = async (taskId, newStatus) => {
    try {
      await api.put(`/Tasks/${taskId}/status`, { status: newStatus });
      loadTasks();
    } catch (err) {
      console.error("Failed to update status", err);
    }
  };

  const handleDelete = async (taskId) => {
    if (!window.confirm("Delete this task?")) return;
    try {
      await api.delete(`/tasks/${taskId}`);
      loadTasks();
    } catch (err) {
      console.error("Failed to delete task", err);
    }
  };

  return (
    <div className="container">
      <h2>Tasks</h2>

      {/* --- Create Task Form (Admin / Manager only) --- */}
      {canCreateTasks && (
        <div className="card">
          <h3>Create New Task</h3>
          {formError && <div className="error-message">{formError}</div>}

          <form onSubmit={handleCreateTask}>
            <div className="form-group">
              <label>Title</label>
              <input value={title} onChange={(e) => setTitle(e.target.value)} required />
            </div>

            <div className="form-group">
              <label>Description</label>
              <textarea value={description} onChange={(e) => setDescription(e.target.value)} rows={3} />
            </div>

            <div className="form-group">
              <label>Assign To</label>
              <select value={assignedToId} onChange={(e) => setAssignedToId(e.target.value)} required>
                <option value="">-- Select a user --</option>
                {users.map((u) => (
                  <option key={u.id} value={u.id}>
                    {u.fullName} ({u.role})
                  </option>
                ))}
              </select>
            </div>

            <div className="form-group">
              <label>Priority</label>
              <select value={priority} onChange={(e) => setPriority(e.target.value)}>
                <option value="Low">Low</option>
                <option value="Medium">Medium</option>
                <option value="High">High</option>
              </select>
            </div>

            <div className="form-group">
              <label>Deadline</label>
              <input type="date" value={deadline} onChange={(e) => setDeadline(e.target.value)} />
            </div>

            <button type="submit" className="primary">Create Task</button>
          </form>
        </div>
      )}

      {/* --- Filters --- */}
      <div className="filters">
        <select value={statusFilter} onChange={(e) => setStatusFilter(e.target.value)}>
          <option value="">All Statuses</option>
          <option value="To Do">To Do</option>
          <option value="In Progress">In Progress</option>
          <option value="Done">Done</option>
        </select>

        <select value={priorityFilter} onChange={(e) => setPriorityFilter(e.target.value)}>
          <option value="">All Priorities</option>
          <option value="Low">Low</option>
          <option value="Medium">Medium</option>
          <option value="High">High</option>
        </select>

        <input
          type="date"
          value={deadlineFilter}
          onChange={(e) => setDeadlineFilter(e.target.value)}
        />
      </div>

      {/* --- Task List --- */}
      {tasks.length === 0 && <p>No tasks found.</p>}

      {tasks.map((t) => (
        <div className="card" key={t.id}>
          <div style={{ display: "flex", justifyContent: "space-between" }}>
            <div>
              <h3 style={{ margin: "0 0 5px 0" }}>{t.title}</h3>
              <p style={{ margin: "0 0 8px 0", color: "#555" }}>{t.description}</p>
              <span className={statusBadgeClass(t.status)}>{t.status}</span>{" "}
              <span style={{ marginLeft: 8 }}>Priority: {t.priority}</span>
              {t.deadline && (
                <span style={{ marginLeft: 8 }}>
                  Deadline: {new Date(t.deadline).toLocaleDateString()}
                </span>
              )}
              <p style={{ fontSize: 13, color: "#888", marginTop: 8 }}>
                Assigned to: {t.assignedTo?.fullName} | Assigned by: {t.assignedBy?.fullName}
              </p>
            </div>

            {canCreateTasks && (
              <button className="danger" onClick={() => handleDelete(t.id)}>
                Delete
              </button>
            )}
          </div>

          {/* Status update dropdown */}
          <div className="form-group" style={{ maxWidth: 200 }}>
            <label>Update Status</label>
            <select value={t.status} onChange={(e) => handleStatusChange(t.id, e.target.value)}>
              <option value="To Do">To Do</option>
              <option value="In Progress">In Progress</option>
              <option value="Done">Done</option>
            </select>
          </div>

          <button
            className="primary"
            style={{ backgroundColor: "#7f8c8d", marginBottom: 8 }}
            onClick={() => setExpandedTaskId(expandedTaskId === t.id ? null : t.id)}
          >
            {expandedTaskId === t.id ? "Hide Comments" : "Show Comments"}
          </button>

          {expandedTaskId === t.id && <CommentSection taskId={t.id} />}
        </div>
      ))}
    </div>
  );
}

export default Tasks;
