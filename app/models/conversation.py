from datetime import datetime, timezone
from app.exts import db
import uuid

class Conversation(db.Model):
    """聊天会话表"""
    __tablename__ = 'conversations'
    
    conversation_id = db.Column(
        db.String(36), 
        primary_key=True, 
        default=lambda: str(uuid.uuid4()),
        comment='会话唯一标识符(UUID格式)'
    )
    conversation_name = db.Column(
        db.String(100),
        comment='会话名称(群聊时显示)'
    )
    is_group = db.Column(
        db.Boolean, 
        default=False,
        comment='是否为群组会话(true=群聊, false=私聊)'
    )
    created_by = db.Column(
        db.String(36), 
        db.ForeignKey('users.user_id'),
        comment='会话创建者用户ID'
    )
    created_at = db.Column(
        db.DateTime, 
        default=datetime.now(timezone.utc),
        comment='会话创建时间'
    )
    updated_at = db.Column(
        db.DateTime, 
        default=datetime.now(timezone.utc), 
        onupdate=datetime.now(timezone.utc),
        comment='最后更新时间'
    )
    
    # 关系定义
    members = db.relationship(
        'ConversationMember', 
        back_populates='conversation',
        comment='会话成员关系'
    )
    messages = db.relationship(
        'Message', 
        back_populates='conversation',
        comment='会话中的消息'
    )

