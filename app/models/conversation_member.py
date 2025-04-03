from datetime import datetime, timezone
from app.exts import db
import uuid


class ConversationMember(db.Model):
    """会话成员关系表"""
    __tablename__ = 'conversation_members'
    
    conversation_id = db.Column(
        db.String(36), 
        db.ForeignKey('conversations.conversation_id'),
        primary_key=True,
        comment='所属会话ID'
    )
    user_id = db.Column(
        db.String(36), 
        db.ForeignKey('users.user_id'),
        primary_key=True,
        comment='成员用户ID'
    )
    joined_at = db.Column(
        db.DateTime, 
        default=datetime.now(timezone.utc),
        comment='加入会话时间'
    )
    role = db.Column(
        db.String(10), 
        default='member',
        comment='成员角色(admin=管理员, member=普通成员)'
    )
    
    # 关系定义
    conversation = db.relationship(
        'Conversation', 
        back_populates='members',
        comment='所属会话'
    )
    user = db.relationship(
        'User', 
        back_populates='conversations',
        comment='成员用户'
    )
