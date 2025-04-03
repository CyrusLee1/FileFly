from datetime import datetime, timezone
from app.exts import db

class MessageReadStatus(db.Model):
    """消息阅读状态表"""
    __tablename__ = 'message_read_status'
    
    message_id = db.Column(
        db.String(36), 
        db.ForeignKey('messages.message_id'),
        primary_key=True,
        comment='消息ID'
    )
    user_id = db.Column(
        db.String(36), 
        db.ForeignKey('users.user_id'),
        primary_key=True,
        comment='用户ID'
    )
    read_at = db.Column(
        db.DateTime, 
        default=datetime.now(timezone.utc),
        comment='阅读时间'
    )
    
    # 关系定义
    message = db.relationship(
        'Message', 
        back_populates='read_statuses',
        comment='关联的消息'
    )
    user = db.relationship(
        'User',
        comment='阅读消息的用户'
    )
