import axios from "axios";

// Change this if your backend runs on a different port
const API_BASE_URL = "https://localhost:7110/api";

const api = axios.create({
  baseURL: API_BASE_URL,
});

// This runs before every request. It automatically attaches the
// JWT token (if we have one) so the backend knows who we are.
api.interceptors.request.use((config) => {
  const token = localStorage.getItem("token");
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export default api;
