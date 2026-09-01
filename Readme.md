# Task Management System

A full-stack task management app with role-based access (Admin / Manager / User),
built with **ASP.NET Core Web API** (backend) and **React** (frontend), using
**SQL Server** as the database.

---

## Project Structure

```
TaskManagementSystem/
├── backend/
│   └── TaskManagementAPI/       # ASP.NET Core Web API
└── frontend/
    └── task-management-frontend/ # React app
```

---

## 1. Backend Setup (ASP.NET Core API)

### Requirements
- .NET SDK (8.0 recommended — check your installed version with `dotnet --version`)
- SQL Server (LocalDB, SQL Express, or full SQL Server all work)

### Step 1: Create the database
Run the included SQL script (`TaskManagementDB_schema.sql`) against your SQL Server
instance. This creates all required tables: `Users`, `Teams`, `Tasks`, `Comments`,
`Notifications`.

You can run it using:
- **SSMS (SQL Server Management Studio)** — open the script, connect to your server, hit Execute, or
- **Azure Data Studio**, or
- `sqlcmd` from the command line

### Step 2: Update the connection string
Open `backend/TaskManagementAPI/appsettings.json` and update the
`ConnectionStrings.DefaultConnection` value to match **your own SQL Server setup**.

**If using LocalDB** (default with Visual Studio installs):
```json
"ConnectionStrings": {
  "DefaultConnection": "Server=(localdb)\\MSSQLLocalDB;Database=TaskManagementDB;Trusted_Connection=True;TrustServerCertificate=True;"
}
```

**If using a named SQL Server Express instance:**
```json
"ConnectionStrings": {
  "DefaultConnection": "Server=localhost\\SQLEXPRESS;Database=TaskManagementDB;Trusted_Connection=True;TrustServerCertificate=True;"
}
```

**If using SQL Server login (username/password) instead of Windows auth:**
```json
"ConnectionStrings": {
  "DefaultConnection": "Server=localhost;Database=TaskManagementDB;User Id=your_username;Password=your_password;TrustServerCertificate=True;"
}
```

> To find your exact server name: open SSMS → the "Server name" dropdown on the
> connect screen shows your actual instance name.

### Step 3: Run the backend
From inside `backend/TaskManagementAPI/`:
```
dotnet restore
dotnet run
```

Or open the `.csproj` in Visual Studio and press **F5**.

### Which port does the backend run on?

The exact port is assigned automatically and printed in your terminal/console
when you run the app — look for a line like:
```
Now listening on: https://localhost:XXXXX
```

Common defaults are `https://localhost:5001` or a Visual-Studio-assigned port
like `https://localhost:44336`. **Whatever port is shown there is your real
backend URL** — copy it, since you'll need it in the frontend setup below.

Swagger UI (to test the API directly) is available at:
```
https://localhost:<your-port>/swagger
```

---

## 2. Frontend Setup (React)

### Requirements
- Node.js (LTS version recommended) — check with `node -v`

### Step 1: Install dependencies
From inside `frontend/task-management-frontend/`:
```
npm install
```

### Step 2: Point the frontend at your backend port
Open `frontend/task-management-frontend/src/api/axios.js` and update the
`API_BASE_URL` to match the port your backend is actually running on
(see the "Which port does the backend run on?" section above):

```js
const API_BASE_URL = "https://localhost:<your-backend-port>/api";
```

Example:
```js
const API_BASE_URL = "https://localhost:44336/api";
```

### Step 3: Run the frontend
```
npm start
```

This runs the React dev server at:
```
http://localhost:3000
```
and opens it automatically in your browser.

> Note: the backend's CORS policy (`Program.cs`) only allows requests from
> `http://localhost:3000`. If you run the frontend on a different port, update
> the `WithOrigins(...)` line in `Program.cs` to match.

---

## 3. First-time Login

Passwords are hashed with BCrypt — you **cannot** log in with placeholder/fake
hash values. To create your first real user:

1. Go to Swagger (`https://localhost:<backend-port>/swagger`) or use the
   frontend's Register page.
2. Call `POST /api/auth/register` with a body like:
   ```json
   {
     "fullName": "Admin User",
     "email": "admin@example.com",
     "password": "Admin@123",
     "role": "Admin"
   }
   ```
3. Then log in with the same email/password via `POST /api/auth/login` or the
   frontend's Login page.

---

## 4. Ports Summary

| Service   | Default URL                          | Notes                                 |
|-----------|---------------------------------------|----------------------------------------|
| Backend   | `https://localhost:<assigned-port>`   | Port shown in console on `dotnet run` |
| Frontend  | `http://localhost:3000`               | Fixed by `react-scripts start`        |
| Swagger   | `https://localhost:<port>/swagger`    | Same port as backend                  |

---

## Troubleshooting

- **"Could not open a connection to SQL Server"** → double-check the
  `Server=` value in your connection string matches your actual SQL Server
  instance name (see Step 2 above).
- **"Invalid column name..."** → make sure the database was created using the
  provided SQL script, and matches the models in `backend/TaskManagementAPI/Models/`.
- **BCrypt "Invalid salt version"** → don't insert fake/placeholder password
  hashes directly into the database; always create users through the
  `/api/auth/register` endpoint so passwords are hashed correctly.
- **Frontend can't reach the backend / network errors** → confirm
  `API_BASE_URL` in `axios.js` matches the exact port your backend printed on
  startup.