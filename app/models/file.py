from datetime import datetime, timezone
from app.exts import db
import uuid

class File(db.Model):
    """文件表"""
    __tablename__ = 'files'
    
    file_id = db.Column(
        db.String(36), 
        primary_key=True, 
        default=lambda: str(uuid.uuid4()),
        comment='文件唯一标识符(UUID格式)'
    )
    original_name = db.Column(
        db.String(255), 
        nullable=False,
        comment='文件原始名称'
    )
    stored_name = db.Column(
        db.String(255), 
        nullable=False,
        comment='文件存储名称(防止冲突)'
    )
    file_path = db.Column(
        db.String(512), 
        nullable=False,
        comment='文件服务器存储路径'
    )
    file_type = db.Column(
        db.String(100), 
        nullable=False,
        comment='文件MIME类型'
    )
    file_size = db.Column(
        db.BigInteger, 
        nullable=False,
        comment='文件大小(字节)'
    )
    uploaded_by = db.Column(
        db.String(36), 
        db.ForeignKey('users.user_id'),
        comment='上传者用户ID'
    )
    uploaded_at = db.Column(
        db.DateTime, 
        default=datetime.now(timezone.utc),
        comment='上传时间'
    )
    expires_at = db.Column(
        db.DateTime,
        comment='文件过期时间(为空表示永久保存)'
    )
    is_public = db.Column(
        db.Boolean, 
        default=False,
        comment='是否公开访问(true=无需登录可访问)'
    )
    
    # 关系定义
    uploader = db.relationship(
        'User', 
        back_populates='uploaded_files',
        comment='上传者'
    )
    message = db.relationship(
        'Message', 
        back_populates='file',
        comment='关联的消息'
    )
