-- 创建数据库
CREATE DATABASE chat_app;
USE chat_app;

-- 用户表 - 存储所有用户信息
CREATE TABLE users (
    user_id VARCHAR(36) PRIMARY KEY COMMENT '用户唯一标识符(UUID格式)',
    username VARCHAR(50) UNIQUE NOT NULL COMMENT '用户名，用于登录和显示',
    email VARCHAR(100) UNIQUE NOT NULL COMMENT '用户邮箱，用于找回密码等',
    password_hash VARCHAR(255) NOT NULL COMMENT '加密后的密码(使用bcrypt等算法)',
    avatar_url VARCHAR(255) COMMENT '用户头像URL地址',
    status ENUM('online', 'offline', 'away', 'busy') DEFAULT 'offline' COMMENT '用户当前在线状态',
    last_seen TIMESTAMP COMMENT '用户最后活动时间',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '账号创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间'
) COMMENT '系统用户信息表';

-- 聊天会话表 - 存储聊天会话信息
CREATE TABLE conversations (
    conversation_id VARCHAR(36) PRIMARY KEY COMMENT '会话唯一标识符(UUID格式)',
    conversation_name VARCHAR(100) COMMENT '会话名称(群聊时显示)',
    is_group BOOLEAN DEFAULT FALSE COMMENT '是否为群组会话(true=群聊, false=私聊)',
    created_by VARCHAR(36) COMMENT '会话创建者用户ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '会话创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL
) COMMENT '聊天会话主表';

-- 会话成员表 - 记录哪些用户参与了哪些会话
CREATE TABLE conversation_members (
    conversation_id VARCHAR(36) COMMENT '所属会话ID',
    user_id VARCHAR(36) COMMENT '成员用户ID',
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '加入会话时间',
    role ENUM('admin', 'member') DEFAULT 'member' COMMENT '成员角色(admin=管理员)',
    PRIMARY KEY (conversation_id, user_id),
    FOREIGN KEY (conversation_id) REFERENCES conversations(conversation_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) COMMENT '会话成员关系表';

-- 文件表 - 存储用户上传的文件信息
CREATE TABLE files (
    file_id VARCHAR(36) PRIMARY KEY COMMENT '文件唯一标识符(UUID格式)',
    original_name VARCHAR(255) NOT NULL COMMENT '文件原始名称',
    stored_name VARCHAR(255) NOT NULL COMMENT '文件存储名称(防止冲突)',
    file_path VARCHAR(512) NOT NULL COMMENT '文件服务器存储路径',
    file_type VARCHAR(100) NOT NULL COMMENT '文件MIME类型',
    file_size BIGINT NOT NULL COMMENT '文件大小(字节)',
    uploaded_by VARCHAR(36) COMMENT '上传者用户ID',
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
    expires_at TIMESTAMP COMMENT '文件过期时间(为空表示永久保存)',
    is_public BOOLEAN DEFAULT FALSE COMMENT '是否公开访问(true=无需登录可访问)',
    FOREIGN KEY (uploaded_by) REFERENCES users(user_id) ON DELETE SET NULL
) COMMENT '用户上传文件信息表';

-- 消息表 - 存储所有聊天消息
CREATE TABLE messages (
    message_id VARCHAR(36) PRIMARY KEY COMMENT '消息唯一标识符(UUID格式)',
    conversation_id VARCHAR(36) COMMENT '所属会话ID',
    sender_id VARCHAR(36) COMMENT '发送者用户ID',
    content TEXT COMMENT '消息文本内容(如果是文件消息可为空或包含描述)',
    is_file BOOLEAN DEFAULT FALSE COMMENT '是否为文件消息(true=文件消息)',
    file_id VARCHAR(36) COMMENT '关联的文件ID(当is_file=true时)',
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '消息发送时间',
    delivered_at TIMESTAMP COMMENT '消息送达时间',
    read_at TIMESTAMP COMMENT '消息被阅读时间',
    deleted BOOLEAN DEFAULT FALSE COMMENT '是否已删除(true=用户已删除)',
    deleted_at TIMESTAMP COMMENT '删除时间',
    FOREIGN KEY (conversation_id) REFERENCES conversations(conversation_id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (file_id) REFERENCES files(file_id) ON DELETE SET NULL
) COMMENT '聊天消息主表';

-- 消息已读状态表 - 记录消息被哪些用户阅读过
CREATE TABLE message_read_status (
    message_id VARCHAR(36) COMMENT '消息ID',
    user_id VARCHAR(36) COMMENT '用户ID',
    read_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '阅读时间',
    PRIMARY KEY (message_id, user_id),
    FOREIGN KEY (message_id) REFERENCES messages(message_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) COMMENT '消息阅读状态跟踪表';

-- 用户设置表 - 存储用户的个性化设置
CREATE TABLE user_settings (
    user_id VARCHAR(36) PRIMARY KEY COMMENT '用户ID',
    theme VARCHAR(20) DEFAULT 'light' COMMENT '界面主题(light/dark等)',
    notification_enabled BOOLEAN DEFAULT TRUE COMMENT '是否启用通知',
    message_preview_enabled BOOLEAN DEFAULT TRUE COMMENT '是否显示消息预览',
    language VARCHAR(10) DEFAULT 'en' COMMENT '用户界面语言',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) COMMENT '用户个性化设置表';

-- 创建索引以提高查询性能
CREATE INDEX idx_conversation_members_user ON conversation_members(user_id) COMMENT '加速按用户查找会话';
CREATE INDEX idx_messages_conversation ON messages(conversation_id, sent_at) COMMENT '加速按会话获取消息';
CREATE INDEX idx_messages_sender ON messages(sender_id) COMMENT '加速查找用户发送的消息';
CREATE INDEX idx_files_uploader ON files(uploaded_by) COMMENT '加速查找用户上传的文件';