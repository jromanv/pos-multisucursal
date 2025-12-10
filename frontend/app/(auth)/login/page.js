'use client';

import { useState } from 'react';
import { useAuth } from '@/contexts/AuthContext';
import { useRouter } from 'next/navigation';

export default function LoginPage() {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');
    const [cargando, setCargando] = useState(false);
    const { login } = useAuth();
    const router = useRouter();

    const handleSubmit = async (e) => {
        e.preventDefault();
        setError('');
        setCargando(true);

        const resultado = await login(email, password);

        if (resultado.success) {
            router.push('/dashboard');
        } else {
            setError(resultado.message);
        }

        setCargando(false);
    };

    return (
        <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-500 to-purple-600">
            <div className="bg-white rounded-lg shadow-2xl p-8 w-full max-w-md">
                {/* Logo / Título */}
                <div className="text-center mb-8">
                    <div className="bg-gradient-to-r from-blue-600 to-purple-600 text-white w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                        <svg
                            className="w-8 h-8"
                            fill="none"
                            stroke="currentColor"
                            viewBox="0 0 24 24"
                        >
                            <path
                                strokeLinecap="round"
                                strokeLinejoin="round"
                                strokeWidth={2}
                                d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"
                            />
                        </svg>
                    </div>
                    <h1 className="text-3xl font-bold text-gray-800">POS Multisucursal</h1>
                    <p className="text-gray-600 mt-2">Inicia sesión para continuar</p>
                </div>

                {/* Formulario */}
                <form onSubmit={handleSubmit} className="space-y-6">
                    {/* Error */}
                    {error && (
                        <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg">
                            <p className="text-sm">{error}</p>
                        </div>
                    )}

                    {/* Email */}
                    <div>
                        <label htmlFor="email" className="block text-sm font-medium text-gray-700 mb-2">
                            Correo Electrónico
                        </label>
                        <input
                            id="email"
                            type="email"
                            value={email}
                            onChange={(e) => setEmail(e.target.value)}
                            required
                            className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition"
                            placeholder="usuario@empresa.com"
                        />
                    </div>

                    {/* Password */}
                    <div>
                        <label htmlFor="password" className="block text-sm font-medium text-gray-700 mb-2">
                            Contraseña
                        </label>
                        <input
                            id="password"
                            type="password"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                            required
                            className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition"
                            placeholder="••••••••"
                        />
                    </div>

                    {/* Botón */}
                    <button
                        type="submit"
                        disabled={cargando}
                        className="w-full bg-gradient-to-r from-blue-600 to-purple-600 text-white py-3 rounded-lg font-semibold hover:from-blue-700 hover:to-purple-700 transition duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                        {cargando ? 'Iniciando sesión...' : 'Iniciar Sesión'}
                    </button>
                </form>

                {/* Info de prueba */}
                <div className="mt-6 p-4 bg-gray-50 rounded-lg">
                    <p className="text-xs text-gray-600 font-semibold mb-2">Usuarios de prueba:</p>
                    <div className="text-xs text-gray-500 space-y-1">
                        <p>• admin@empresa.com</p>
                        <p>• propietario@empresa.com</p>
                        <p>• vendedor1@empresa.com</p>
                        <p className="mt-2">Contraseña: <span className="font-mono">Admin123!</span></p>
                    </div>
                </div>
            </div>
        </div>
    );
}