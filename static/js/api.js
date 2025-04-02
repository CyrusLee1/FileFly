// api.js - 集中管理所有API请求

const API_BASE_URL = 'http://127.0.0.1:5000';

// 通用请求函数
async function makeRequest(endpoint, method = 'GET', data = null) {
    const url = `${API_BASE_URL}${endpoint}`;
    const options = {
        method,
        headers: {
            'Content-Type': 'application/json',
            // 可以在这里添加认证头等
            //'Authorization': localStorage.getItem('token') ? `Bearer ${localStorage.getItem('token')}` : ''
        }
    };

    if (data) {
        options.body = JSON.stringify(data);
    }

    try {
        const response = await fetch(url, options);
        
        if (!response.ok) {
            const error = await response.json();
            throw new Error(error.message || '请求失败');
        }
        
        return await response.json();
    } catch (error) {
        console.error('API请求错误:', error);
        throw error; // 继续抛出错误让调用方处理
    }
}

// 具体的API函数
export const api = {
    // 用户相关
    getUser: (userId) => makeRequest(`/users/${userId}`),
    createUser: (userData) => makeRequest('/users', 'POST', userData),
    updateUser: (userId, userData) => makeRequest(`/users/${userId}`, 'PUT', userData),
    deleteUser: (userId) => makeRequest(`/users/${userId}`, 'DELETE'),
    
    // 产品相关
    getProducts: () => makeRequest('/products'),
    getProductById: (productId) => makeRequest(`/products/${productId}`),
    
    // 订单相关
    createOrder: (orderData) => makeRequest('/orders', 'POST', orderData),
    
    getMessages: () => makeRequest('/message/all')
};