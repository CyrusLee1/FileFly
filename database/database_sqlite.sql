-- 网页聊天工具SQLite数据库脚本
-- 注意：SQLite不支持列注释和ENUM类型，我已做了相应调整

-- 用户表 - 存储所有用户信息
CREATE TABLE users (
    user_id TEXT PRIMARY KEY,               -- 用户唯一标识符(UUID格式)
    username TEXT UNIQUE NOT NULL,          -- 用户名，用于登录和显示
    email TEXT UNIQUE NOT NULL,             -- 用户邮箱，用于找回密码等
    password_hash TEXT NOT NULL,            -- 加密后的密码(使用bcrypt等算法)
    avatar_url TEXT,                        -- 用户头像URL地址
    status TEXT CHECK(status IN ('online', 'offline', 'away', 'busy')) DEFAULT 'offline', -- 用户当前在线状态
    last_seen TIMESTAMP,                    -- 用户最后活动时间
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 账号创建时间
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- 最后更新时间
);

-- 聊天会话表 - 存储聊天会话信息
CREATE TABLE conversations (
    conversation_id TEXT PRIMARY KEY,       -- 会话唯一标识符(UUID格式)
    conversation_name TEXT,                 -- 会话名称(群聊时显示)
    is_group BOOLEAN DEFAULT FALSE,         -- 是否为群组会话(true=群聊, false=私聊)
    created_by TEXT,                        -- 会话创建者用户ID
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 会话创建时间
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 最后更新时间
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL
);

-- 会话成员表 - 记录哪些用户参与了哪些会话
CREATE TABLE conversation_members (
    conversation_id TEXT,                  -- 所属会话ID
    user_id TEXT,                           -- 成员用户ID
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 加入会话时间
    role TEXT CHECK(role IN ('admin', 'member')) DEFAULT 'member',  -- 成员角色(admin=管理员)
    PRIMARY KEY (conversation_id, user_id),
    FOREIGN KEY (conversation_id) REFERENCES conversations(conversation_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 文件表 - 存储用户上传的文件信息
CREATE TABLE files (
    file_id TEXT PRIMARY KEY,               -- 文件唯一标识符(UUID格式)
    original_name TEXT NOT NULL,            -- 文件原始名称
    stored_name TEXT NOT NULL,              -- 文件存储名称(防止冲突)
    file_path TEXT NOT NULL,                -- 文件服务器存储路径
    file_type TEXT NOT NULL,                -- 文件MIME类型
    file_size INTEGER NOT NULL,             -- 文件大小(字节)
    uploaded_by TEXT,                       -- 上传者用户ID
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 上传时间
    expires_at TIMESTAMP,                   -- 文件过期时间(为空表示永久保存)
    is_public BOOLEAN DEFAULT FALSE,        -- 是否公开访问(true=无需登录可访问)
    FOREIGN KEY (uploaded_by) REFERENCES users(user_id) ON DELETE SET NULL
);

-- 消息表 - 存储所有聊天消息
CREATE TABLE messages (
    message_id TEXT PRIMARY KEY,            -- 消息唯一标识符(UUID格式)
    conversation_id TEXT,                   -- 所属会话ID
    sender_id TEXT,                         -- 发送者用户ID
    content TEXT,                           -- 消息文本内容(如果是文件消息可为空或包含描述)
    is_file BOOLEAN DEFAULT FALSE,          -- 是否为文件消息(true=文件消息)
    file_id TEXT,                           -- 关联的文件ID(当is_file=true时)
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 消息发送时间
    delivered_at TIMESTAMP,                 -- 消息送达时间
    read_at TIMESTAMP,                      -- 消息被阅读时间
    deleted BOOLEAN DEFAULT FALSE,          -- 是否已删除(true=用户已删除)
    deleted_at TIMESTAMP,                   -- 删除时间
    FOREIGN KEY (conversation_id) REFERENCES conversations(conversation_id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (file_id) REFERENCES files(file_id) ON DELETE SET NULL
);

-- 消息已读状态表 - 记录消息被哪些用户阅读过
CREATE TABLE message_read_status (
    message_id TEXT,                       -- 消息ID
    user_id TEXT,                          -- 用户ID
    read_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 阅读时间
    PRIMARY KEY (message_id, user_id),
    FOREIGN KEY (message_id) REFERENCES messages(message_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 用户设置表 - 存储用户的个性化设置
CREATE TABLE user_settings (
    user_id TEXT PRIMARY KEY,              -- 用户ID
    theme TEXT DEFAULT 'light',            -- 界面主题(light/dark等)
    notification_enabled BOOLEAN DEFAULT TRUE,  -- 是否启用通知
    message_preview_enabled BOOLEAN DEFAULT TRUE,  -- 是否显示消息预览
    language TEXT DEFAULT 'en',            -- 用户界面语言
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 最后更新时间
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 创建索引以提高查询性能
CREATE INDEX idx_conversation_members_user ON conversation_members(user_id);  -- 加速按用户查找会话
CREATE INDEX idx_messages_conversation ON messages(conversation_id, sent_at); -- 加速按会话获取消息
CREATE INDEX idx_messages_sender ON messages(sender_id);                      -- 加速查找用户发送的消息
CREATE INDEX idx_files_uploader ON files(uploaded_by);                       -- 加速查找用户上传的文件