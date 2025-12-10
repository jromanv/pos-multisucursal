'use client';

import { useAuth } from '@/contexts/AuthContext';
import { useRouter } from 'next/navigation';
import { useEffect } from 'react';

export default function DashboardPage() {
    const { usuario, logout, cargando } = useAuth();
    const router = useRouter();

    useEffect(() => {
        if (!cargando && !usuario) {
            router.push('/login');
        }
    }, [usuario, cargando, router]);

    if (cargando) {
        return (
            <div className="min-h-screen flex items-center justify-center">
                <div className="text-center">
                    <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
                    <p className="mt-4 text-gray-600">Cargando...</p>
                </div>
            </div>
        );
    }

    if (!usuario) {
        return null;
    }

    return (
        <div className="min-h-screen bg-gray-100">
            {/* Header */}
            <header className="bg-white shadow">
                <div className="max-w-7xl mx-auto px-4 py-4 sm:px-6 lg:px-8 flex justify-between items-center">
                    <h1 className="text-2xl font-bold text-gray-900">Dashboard</h1>
                    <button
                        onClick={logout}
                        className="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition"
                    >
                        Cerrar Sesión
                    </button>
                </div>
            </header>

            {/* Contenido */}
            <main className="max-w-7xl mx-auto px-4 py-6 sm:px-6 lg:px-8">
                <div className="bg-white rounded-lg shadow p-6">
                    <h2 className="text-xl font-semibold mb-4">Bienvenido</h2>
                    <div className="space-y-2">
                        <p><strong>Nombre:</strong> {usuario.nombre} {usuario.apellido}</p>
                        <p><strong>Email:</strong> {usuario.email}</p>
                        <p><strong>Rol:</strong> <span className="px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-sm">{usuario.rol}</span></p>
                        {usuario.sucursal_nombre && (
                            <p><strong>Sucursal:</strong> {usuario.sucursal_nombre}</p>
                        )}
                    </div>
                </div>

                <div className="mt-6 bg-blue-50 border border-blue-200 rounded-lg p-6">
                    <h3 className="text-lg font-semibold text-blue-900 mb-2">🎉 ¡Sistema Funcionando!</h3>
                    <p className="text-blue-700">
                        El sistema de autenticación está operativo. En los siguientes pasos agregaremos más funcionalidades.
                    </p>
                </div>
            </main>
        </div>
    );
}