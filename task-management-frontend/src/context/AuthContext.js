import React, { createContext, useState, useContext } from "react";

// This Context lets any component in the app know:
// - Is someone logged in?
// - What is their name/role?
// - Functions to log in / log out

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  // On page load, try to restore the user from localStorage
  const [user, setUser] = useState(() => {
    const saved = localStorage.getItem("user");
    return saved ? JSON.parse(saved) : null;
  });

  const login = (authResponse) => {
    // authResponse comes from the backend: { token, fullName, email, role, userId }
    localStorage.setItem("token", authResponse.token);
    localStorage.setItem("user", JSON.stringify(authResponse));
    setUser(authResponse);
  };

  const logout = () => {
    localStorage.removeItem("token");
    localStorage.removeItem("user");
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

// Custom hook so components can simply do: const { user, login, logout } = useAuth();
export function useAuth() {
  return useContext(AuthContext);
}
