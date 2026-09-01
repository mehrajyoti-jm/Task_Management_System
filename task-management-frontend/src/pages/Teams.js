import React, { useEffect, useState } from "react";
import api from "../api/axios";

function Teams() {
  const [teams, setTeams] = useState([]);
  const [users, setUsers] = useState([]);

  // New team form
  const [teamName, setTeamName] = useState("");
  const [managerId, setManagerId] = useState("");

  // Assign user form
  const [selectedUserId, setSelectedUserId] = useState("");
  const [selectedTeamId, setSelectedTeamId] = useState("");

  const [message, setMessage] = useState("");

  useEffect(() => {
    loadTeams();
    loadUsers();
  }, []);

  const loadTeams = async () => {
    try {
      const res = await api.get("/teams");
      setTeams(res.data);
    } catch (err) {
      console.error("Failed to load teams", err);
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

  const handleCreateTeam = async (e) => {
    e.preventDefault();
    try {
      await api.post("/teams", {
        name: teamName,
        managerId: managerId ? parseInt(managerId, 10) : null,
      });
      setTeamName("");
      setManagerId("");
      loadTeams();
    } catch (err) {
      console.error("Failed to create team", err);
    }
  };

  const handleAssignUser = async (e) => {
    e.preventDefault();
    setMessage("");
    try {
      const res = await api.post("/teams/assign-user", {
        userId: parseInt(selectedUserId, 10),
        teamId: parseInt(selectedTeamId, 10),
      });
      setMessage(res.data.message);
      loadTeams();
      loadUsers();
    } catch (err) {
      setMessage(err.response?.data?.message || "Failed to assign user.");
    }
  };

  const managers = users.filter((u) => u.role === "Manager" || u.role === "Admin");

  return (
    <div className="container">
      <h2>Team Management</h2>

      <div className="card">
        <h3>Create Team</h3>
        <form onSubmit={handleCreateTeam}>
          <div className="form-group">
            <label>Team Name</label>
            <input value={teamName} onChange={(e) => setTeamName(e.target.value)} required />
          </div>

          <div className="form-group">
            <label>Manager (optional)</label>
            <select value={managerId} onChange={(e) => setManagerId(e.target.value)}>
              <option value="">-- None --</option>
              {managers.map((m) => (
                <option key={m.id} value={m.id}>
                  {m.fullName}
                </option>
              ))}
            </select>
          </div>

          <button type="submit" className="primary">Create Team</button>
        </form>
      </div>

      <div className="card">
        <h3>Assign User to Team</h3>
        {message && <p style={{ color: "#2c7be5" }}>{message}</p>}

        <form onSubmit={handleAssignUser}>
          <div className="form-group">
            <label>User</label>
            <select value={selectedUserId} onChange={(e) => setSelectedUserId(e.target.value)} required>
              <option value="">-- Select user --</option>
              {users.map((u) => (
                <option key={u.id} value={u.id}>
                  {u.fullName} ({u.role})
                </option>
              ))}
            </select>
          </div>

          <div className="form-group">
            <label>Team</label>
            <select value={selectedTeamId} onChange={(e) => setSelectedTeamId(e.target.value)} required>
              <option value="">-- Select team --</option>
              {teams.map((t) => (
                <option key={t.id} value={t.id}>
                  {t.name}
                </option>
              ))}
            </select>
          </div>

          <button type="submit" className="primary">Assign</button>
        </form>
      </div>

      <h3>All Teams</h3>
      {teams.map((t) => (
        <div className="card" key={t.id}>
          <h4>{t.name}</h4>
          <p>Manager: {t.manager?.fullName || "Not assigned"}</p>
          <p>
            Members:{" "}
            {t.members.length === 0
              ? "None yet"
              : t.members.map((m) => m.fullName).join(", ")}
          </p>
        </div>
      ))}
    </div>
  );
}

export default Teams;
