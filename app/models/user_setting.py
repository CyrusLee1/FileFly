from datetime import datetime, timezone
from app.exts import db
import uuid

class UserSetting(db.Model):
    """用户设置表"""
    __tablename__ = 'user_settings'
    
    user_id = db.Column(
        db.String(36), 
        db.ForeignKey('users.user_id'),
        primary_key=True,
        comment='用户ID'
    )
    theme = db.Column(
        db.String(20), 
        default='light',
        comment='界面主题(light/dark等)'
    )
    notification_enabled = db.Column(
        db.Boolean, 
        default=True,
        comment='是否启用通知'
    )
    message_preview_enabled = db.Column(
        db.Boolean, 
        default=True,
        comment='是否显示消息预览'
    )
    language = db.Column(
        db.String(10), 
        default='en',
        comment='用户界面语言'
    )
    updated_at = db.Column(
        db.DateTime, 
        default=datetime.now(timezone.utc), 
        onupdate=datetime.now(timezone.utc),
        comment='最后更新时间'
    )
    
    # 关系定义
    user = db.relationship(
        'User', 
        back_populates='settings',
        comment='所属用户'
    )
    