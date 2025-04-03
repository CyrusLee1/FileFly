from datetime import datetime, timezone
from app.exts import db
import uuid

class Message(db.Model):
    """消息表"""
    __tablename__ = 'messages'
    
    message_id = db.Column(
        db.String(36), 
        primary_key=True, 
        default=lambda: str(uuid.uuid4()),
        comment='消息唯一标识符(UUID格式)'
    )
    conversation_id = db.Column(
        db.String(36), 
        db.ForeignKey('conversations.conversation_id'),
        comment='所属会话ID'
    )
    sender_id = db.Column(
        db.String(36), 
        db.ForeignKey('users.user_id'),
        comment='发送者用户ID'
    )
    content = db.Column(
        db.Text,
        comment='消息文本内容(如果是文件消息可为空或包含描述)'
    )
    is_file = db.Column(
        db.Boolean, 
        default=False,
        comment='是否为文件消息(true=文件消息)'
    )
    file_id = db.Column(
        db.String(36), 
        db.ForeignKey('files.file_id'),
        comment='关联的文件ID(当is_file=true时)'
    )
    sent_at = db.Column(
        db.DateTime, 
        default=datetime.utcnow,
        comment='消息发送时间'
    )
    delivered_at = db.Column(
        db.DateTime,
        comment='消息送达时间'
    )
    read_at = db.Column(
        db.DateTime,
        comment='消息被阅读时间'
    )
    deleted = db.Column(
        db.Boolean, 
        default=False,
        comment='是否已删除(true=用户已删除)'
    )
    deleted_at = db.Column(
        db.DateTime,
        comment='删除时间'
    )
    
    # 关系定义
    conversation = db.relationship(
        'Conversation', 
        back_populates='messages',
        comment='所属会话'
    )
    sender = db.relationship(
        'User', 
        back_populates='sent_messages',
        comment='发送者'
    )
    file = db.relationship(
        'File', 
        back_populates='message',
        comment='关联的文件(如果是文件消息)'
    )
    read_statuses = db.relationship(
        'MessageReadStatus', 
        back_populates='message',
        comment='消息阅读状态'
    )
