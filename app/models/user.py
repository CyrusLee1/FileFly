from datetime import datetime, timezone
from app.exts import db
import uuid

class User(db.Model):
    """用户信息表"""
    __tablename__ = 'users'
    
    user_id = db.Column(
        db.String(36), 
        primary_key=True, 
        default=lambda: str(uuid.uuid4()),
        comment='用户唯一标识符(UUID格式)'
    )
    username = db.Column(
        db.String(50), 
        unique=True, 
        nullable=False,
        comment='用户名，用于登录和显示'
    )
    email = db.Column(
        db.String(100), 
        unique=True, 
        nullable=False,
        comment='用户邮箱，用于找回密码等'
    )
    password_hash = db.Column(
        db.String(255), 
        nullable=False,
        comment='加密后的密码(使用bcrypt等算法)'
    )
    avatar_url = db.Column(
        db.String(255),
        comment='用户头像URL地址'
    )
    status = db.Column(
        db.String(20), 
        default='offline',
        comment='用户当前在线状态(online/offline/away/busy)'
    )
    last_seen = db.Column(
        db.DateTime,
        comment='用户最后活动时间'
    )
    created_at = db.Column(
        db.DateTime, 
        default=datetime.now(timezone.utc),
        comment='账号创建时间'
    )
    updated_at = db.Column(
        db.DateTime, 
        default=datetime.now(timezone.utc), 
        onupdate=datetime.now(timezone.utc),
        comment='最后更新时间'
    )
    
    # 关系定义
    conversations = db.relationship(
        'ConversationMember', 
        back_populates='user',
        comment='用户参与的会话关系'
    )
    sent_messages = db.relationship(
        'Message', 
        back_populates='sender',
        comment='用户发送的消息'
    )
    uploaded_files = db.relationship(
        'File', 
        back_populates='uploader',
        comment='用户上传的文件'
    )
    settings = db.relationship(
        'UserSetting', 
        back_populates='user', 
        uselist=False,
        comment='用户个人设置'
    )
