const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:5000/api';

/**
 * Realizar petición a la API
 */
export const fetchAPI = async (endpoint, options = {}) => {
    const url = `${API_URL}${endpoint}`;

    const config = {
        headers: {
            'Content-Type': 'application/json',
            ...options.headers,
        },
        ...options,
    };

    // Agregar token si existe
    if (typeof window !== 'undefined') {
        const token = localStorage.getItem('accessToken');
        if (token) {
            config.headers['Authorization'] = `Bearer ${token}`;
        }
    }

    try {
        const response = await fetch(url, config);
        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.message || 'Error en la petición');
        }

        return data;
    } catch (error) {
        throw error;
    }
};

/**
 * Servicio de autenticación
 */
export const authService = {
    login: async (email, password) => {
        return fetchAPI('/auth/login', {
            method: 'POST',
            body: JSON.stringify({ email, password }),
        });
    },

    logout: async () => {
        return fetchAPI('/auth/logout', {
            method: 'POST',
        });
    },

    getPerfil: async () => {
        return fetchAPI('/auth/perfil');
    },

    refreshToken: async (refreshToken) => {
        return fetchAPI('/auth/refresh', {
            method: 'POST',
            body: JSON.stringify({ refreshToken }),
        });
    },
};