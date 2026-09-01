USE [TaskManagementDB]
GO
/****** Object:  Table [dbo].[Comments]    Script Date: 01-09-2026 18:49:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[TaskItemId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Notifications]    Script Date: 01-09-2026 18:49:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Notifications](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[Message] [nvarchar](500) NOT NULL,
	[IsRead] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tasks]    Script Date: 01-09-2026 18:49:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tasks](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](200) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[Status] [nvarchar](20) NOT NULL,
	[Priority] [nvarchar](10) NOT NULL,
	[Deadline] [datetime2](7) NULL,
	[AssignedToId] [int] NOT NULL,
	[AssignedById] [int] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Teams]    Script Date: 01-09-2026 18:49:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Teams](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](150) NOT NULL,
	[ManagerId] [int] NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 01-09-2026 18:49:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FullName] [nvarchar](150) NOT NULL,
	[Email] [nvarchar](200) NOT NULL,
	[PasswordHash] [nvarchar](500) NOT NULL,
	[Role] [nvarchar](20) NOT NULL,
	[TeamId] [int] NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Comments] ON 
GO
INSERT [dbo].[Comments] ([Id], [Text], [TaskItemId], [UserId], [CreatedAt]) VALUES (1, N'Started working on wireframes.', 1, 3, CAST(N'2026-09-01T10:08:43.0802382' AS DateTime2))
GO
SET IDENTITY_INSERT [dbo].[Comments] OFF
GO
SET IDENTITY_INSERT [dbo].[Notifications] ON 
GO
INSERT [dbo].[Notifications] ([Id], [UserId], [Message], [IsRead], [CreatedAt]) VALUES (1, 3, N'You have been assigned a new task: Design homepage mockup', 0, CAST(N'2026-09-01T10:08:43.0817056' AS DateTime2))
GO
INSERT [dbo].[Notifications] ([Id], [UserId], [Message], [IsRead], [CreatedAt]) VALUES (2, 4, N'You have been assigned a new task: "Report Page"', 0, CAST(N'2026-09-01T10:48:40.9970242' AS DateTime2))
GO
INSERT [dbo].[Notifications] ([Id], [UserId], [Message], [IsRead], [CreatedAt]) VALUES (3, 2, N'You have been assigned a new task: "Purchase Order"', 0, CAST(N'2026-09-01T10:59:16.0449418' AS DateTime2))
GO
INSERT [dbo].[Notifications] ([Id], [UserId], [Message], [IsRead], [CreatedAt]) VALUES (4, 4, N'Task "Purchase Order" status was updated to "In Progress".', 0, CAST(N'2026-09-01T11:00:55.0612404' AS DateTime2))
GO
INSERT [dbo].[Notifications] ([Id], [UserId], [Message], [IsRead], [CreatedAt]) VALUES (5, 3, N'You have been assigned a new task: "sdfghbh"', 0, CAST(N'2026-09-01T11:06:57.6355995' AS DateTime2))
GO
SET IDENTITY_INSERT [dbo].[Notifications] OFF
GO
SET IDENTITY_INSERT [dbo].[Tasks] ON 
GO
INSERT [dbo].[Tasks] ([Id], [Title], [Description], [Status], [Priority], [Deadline], [AssignedToId], [AssignedById], [CreatedAt]) VALUES (1, N'Design homepage mockup', N'Create Figma mockup for homepage', N'In Progress', N'High', CAST(N'2026-09-10T00:00:00.0000000' AS DateTime2), 3, 2, CAST(N'2026-09-01T10:08:43.0802382' AS DateTime2))
GO
INSERT [dbo].[Tasks] ([Id], [Title], [Description], [Status], [Priority], [Deadline], [AssignedToId], [AssignedById], [CreatedAt]) VALUES (4, N'sdfghbh', N'sdgd', N'To Do', N'Medium', CAST(N'2026-09-24T00:00:00.0000000' AS DateTime2), 3, 4, CAST(N'2026-09-01T11:06:57.6229453' AS DateTime2))
GO
SET IDENTITY_INSERT [dbo].[Tasks] OFF
GO
SET IDENTITY_INSERT [dbo].[Teams] ON 
GO
INSERT [dbo].[Teams] ([Id], [Name], [ManagerId], [CreatedAt]) VALUES (1, N'Development Team', 2, CAST(N'2026-09-01T10:08:43.0782411' AS DateTime2))
GO
INSERT [dbo].[Teams] ([Id], [Name], [ManagerId], [CreatedAt]) VALUES (2, N'Team 1', 4, CAST(N'2026-09-01T10:54:31.9458829' AS DateTime2))
GO
INSERT [dbo].[Teams] ([Id], [Name], [ManagerId], [CreatedAt]) VALUES (3, N'Team 2', 2, CAST(N'2026-09-01T10:55:06.0523739' AS DateTime2))
GO
INSERT [dbo].[Teams] ([Id], [Name], [ManagerId], [CreatedAt]) VALUES (4, N'Team 3', 2, CAST(N'2026-09-01T10:55:24.6459346' AS DateTime2))
GO
SET IDENTITY_INSERT [dbo].[Teams] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 
GO
INSERT [dbo].[Users] ([Id], [FullName], [Email], [PasswordHash], [Role], [TeamId], [CreatedAt]) VALUES (1, N'Admin', N'admin@example.com', N'$2a$11$.BhPbDMk9duwBNATQ3HszOY9WNlzMy7s8Dq4XQpLJlEylcyKYlMii', N'Admin', NULL, CAST(N'2026-09-01T10:08:43.0741783' AS DateTime2))
GO
INSERT [dbo].[Users] ([Id], [FullName], [Email], [PasswordHash], [Role], [TeamId], [CreatedAt]) VALUES (2, N'Manager', N'john@example.com', N'$2a$11$.BhPbDMk9duwBNATQ3HszOY9WNlzMy7s8Dq4XQpLJlEylcyKYlMii', N'Manager', 1, CAST(N'2026-09-01T10:08:43.0792471' AS DateTime2))
GO
INSERT [dbo].[Users] ([Id], [FullName], [Email], [PasswordHash], [Role], [TeamId], [CreatedAt]) VALUES (3, N'User', N'sara@example.com', N'$2a$11$.BhPbDMk9duwBNATQ3HszOY9WNlzMy7s8Dq4XQpLJlEylcyKYlMii', N'User', 1, CAST(N'2026-09-01T10:08:43.0802382' AS DateTime2))
GO
INSERT [dbo].[Users] ([Id], [FullName], [Email], [PasswordHash], [Role], [TeamId], [CreatedAt]) VALUES (4, N'Jyoti', N'jyoti5283@gmail.com', N'$2a$11$.BhPbDMk9duwBNATQ3HszOY9WNlzMy7s8Dq4XQpLJlEylcyKYlMii', N'Admin', NULL, CAST(N'2026-09-01T10:13:11.8840345' AS DateTime2))
GO
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Users__A9D105343AE87083]    Script Date: 01-09-2026 18:49:23 ******/
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Comments] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Notifications] ADD  DEFAULT ((0)) FOR [IsRead]
GO
ALTER TABLE [dbo].[Notifications] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Tasks] ADD  DEFAULT ('') FOR [Description]
GO
ALTER TABLE [dbo].[Tasks] ADD  DEFAULT ('To Do') FOR [Status]
GO
ALTER TABLE [dbo].[Tasks] ADD  DEFAULT ('Medium') FOR [Priority]
GO
ALTER TABLE [dbo].[Tasks] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Teams] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ('User') FOR [Role]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Comments]  WITH CHECK ADD  CONSTRAINT [FK_Comments_Task] FOREIGN KEY([TaskItemId])
REFERENCES [dbo].[Tasks] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Comments] CHECK CONSTRAINT [FK_Comments_Task]
GO
ALTER TABLE [dbo].[Comments]  WITH CHECK ADD  CONSTRAINT [FK_Comments_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Comments] CHECK CONSTRAINT [FK_Comments_User]
GO
ALTER TABLE [dbo].[Notifications]  WITH CHECK ADD  CONSTRAINT [FK_Notifications_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Notifications] CHECK CONSTRAINT [FK_Notifications_User]
GO
ALTER TABLE [dbo].[Tasks]  WITH CHECK ADD  CONSTRAINT [FK_Tasks_AssignedBy] FOREIGN KEY([AssignedById])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Tasks] CHECK CONSTRAINT [FK_Tasks_AssignedBy]
GO
ALTER TABLE [dbo].[Tasks]  WITH CHECK ADD  CONSTRAINT [FK_Tasks_AssignedTo] FOREIGN KEY([AssignedToId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Tasks] CHECK CONSTRAINT [FK_Tasks_AssignedTo]
GO
ALTER TABLE [dbo].[Teams]  WITH CHECK ADD  CONSTRAINT [FK_Teams_Manager] FOREIGN KEY([ManagerId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Teams] CHECK CONSTRAINT [FK_Teams_Manager]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_Team] FOREIGN KEY([TeamId])
REFERENCES [dbo].[Teams] ([Id])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_Team]
GO
ALTER TABLE [dbo].[Tasks]  WITH CHECK ADD CHECK  (([Priority]='High' OR [Priority]='Medium' OR [Priority]='Low'))
GO
ALTER TABLE [dbo].[Tasks]  WITH CHECK ADD CHECK  (([Status]='Done' OR [Status]='In Progress' OR [Status]='To Do'))
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD CHECK  (([Role]='User' OR [Role]='Manager' OR [Role]='Admin'))
GO
