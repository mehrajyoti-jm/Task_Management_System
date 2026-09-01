import React, { useEffect, useState } from "react";
import api from "../api/axios";

// Shows comments for a task and lets the user add a new one.
function CommentSection({ taskId }) {
  const [comments, setComments] = useState([]);
  const [text, setText] = useState("");

  useEffect(() => {
    loadComments();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [taskId]);

  const loadComments = async () => {
    try {
      const res = await api.get(`/tasks/${taskId}/comments`);
      setComments(res.data);
    } catch (err) {
      console.error("Failed to load comments", err);
    }
  };

  const handleAddComment = async (e) => {
    e.preventDefault();
    if (!text.trim()) return;

    try {
      await api.post(`/tasks/${taskId}/comments`, { text });
      setText("");
      loadComments(); // refresh the list
    } catch (err) {
      console.error("Failed to add comment", err);
    }
  };

  return (
    <div className="comment-box">
      {comments.map((c) => (
        <div key={c.id} className="comment">
          <strong>{c.user?.fullName || "Unknown"}:</strong> {c.text}
        </div>
      ))}

      <form onSubmit={handleAddComment} style={{ display: "flex", gap: 8, marginTop: 8 }}>
        <input
          placeholder="Write a comment..."
          value={text}
          onChange={(e) => setText(e.target.value)}
        />
        <button type="submit" className="primary">Post</button>
      </form>
    </div>
  );
}

export default CommentSection;
