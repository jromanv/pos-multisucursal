'use client';

import { createContext, useContext, useState, useEffect } from 'react';
import { authService } from '@/lib/api';
import { useRouter } from 'next/navigation';

const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
    const [usuario, setUsuario] = useState(null);
    const [cargando, setCargando] = useState(true);
    const router = useRouter();

    useEffect(() => {
        verificarAutenticacion();
    }, []);

    const verificarAutenticacion = async () => {
        try {
            const token = localStorage.getItem('accessToken');
            if (token) {
                const response = await authService.getPerfil();
                setUsuario(response.data);
            }
        } catch (error) {
            console.error('Error al verificar autenticación:', error);
            localStorage.removeItem('accessToken');
            localStorage.removeItem('refreshToken');
        } finally {
            setCargando(false);
        }
    };

    const login = async (email, password) => {
        try {
            const response = await authService.login(email, password);

            localStorage.setItem('accessToken', response.data.accessToken);
            localStorage.setItem('refreshToken', response.data.refreshToken);

            setUsuario(response.data.usuario);

            return { success: true, data: response.data };
        } catch (error) {
            return { success: false, message: error.message };
        }
    };

    const logout = async () => {
        try {
            await authService.logout();
        } catch (error) {
            console.error('Error al cerrar sesión:', error);
        } finally {
            localStorage.removeItem('accessToken');
            localStorage.removeItem('refreshToken');
            setUsuario(null);
            router.push('/login');
        }
    };

    return (
        <AuthContext.Provider value={{ usuario, cargando, login, logout }}>
            {children}
        </AuthContext.Provider>
    );
};

export const useAuth = () => {
    const context = useContext(AuthContext);
    if (!context) {
        throw new Error('useAuth debe usarse dentro de AuthProvider');
    }
    return context;
};