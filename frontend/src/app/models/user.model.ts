export interface User {
  id: string;
  username: string;
  email: string;
  role: 'CLIENT' | 'SELLER';
  fullName?: string;
  phone?: string;
  address?: string;
  avatarUrl?: string;
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface RegisterRequest {
  email: string;
  password: string;
  firstName: string;
  lastName: string;
  role: 'CLIENT' | 'SELLER';
  phone?: string;
}

export interface AuthResponse {
  token: string;
  user: User;
}
