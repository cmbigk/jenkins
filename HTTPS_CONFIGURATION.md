# HTTPS Configuration Guide

## Overview
All backend microservices (user-service, product-service, media-service) have been configured to use HTTPS for secure communication.

## Changes Made

### 1. SSL Certificates Generated
Self-signed SSL certificates have been created for all three services:
- `/user-service/src/main/resources/keystore.p12`
- `/product-service/src/main/resources/keystore.p12`
- `/media-service/src/main/resources/keystore.p12`

**Certificate Details:**
- Type: PKCS12
- Alias: tomcat
- Password: changeit
- Validity: 10 years (3650 days)
- Key Algorithm: RSA 2048-bit

### 2. Application Properties Updated
Each service's `application.properties` file now includes SSL configuration:
```properties
server.ssl.enabled=${SSL_ENABLED:true}
server.ssl.key-store-type=PKCS12
server.ssl.key-store=classpath:keystore.p12
server.ssl.key-store-password=${SSL_KEY_STORE_PASSWORD:changeit}
server.ssl.key-alias=tomcat
```

### 3. Docker Compose Environment Variables
Environment variables added to docker-compose.yml:
```yaml
SSL_ENABLED: true
SSL_KEY_STORE_PASSWORD: changeit
```

### 4. Inter-Service Communication
- Product-service now uses HTTPS to communicate with user-service
- WebClient configured to accept self-signed certificates
- User service URL updated: `https://user-service:8081`

### 5. Frontend Proxy Configuration
Updated `proxy.conf.json` to use HTTPS targets:
```json
{
  "/api/auth": {
    "target": "https://localhost:8081",
    "secure": false
  },
  "/api/products": {
    "target": "https://localhost:8082",
    "secure": false
  },
  "/api/media": {
    "target": "https://localhost:8083",
    "secure": false
  }
}
```

## Accessing Services

### From Browser/Frontend
- User Service: `https://localhost:8081/api/auth/*`
- Product Service: `https://localhost:8082/api/products/*`
- Media Service: `https://localhost:8083/api/media/*`

### From Docker Containers
- User Service: `https://user-service:8081`
- Product Service: `https://product-service:8082`
- Media Service: `https://media-service:8083`

## Browser Security Warning
Since these are self-signed certificates, browsers will show a security warning. For development:
1. Click "Advanced" or "Show Details"
2. Click "Proceed to localhost (unsafe)" or similar option
3. This is expected behavior for self-signed certificates

## Production Considerations
For production deployment:
1. Replace self-signed certificates with CA-signed certificates
2. Use proper domain names instead of localhost
3. Enable stricter SSL validation
4. Consider using Let's Encrypt for free SSL certificates
5. Update `secure: false` to `secure: true` in proxy.conf.json

## Verification
Check if services are running with HTTPS:
```bash
docker logs user-service --tail 20 | grep https
docker logs product-service --tail 20 | grep https
docker logs media-service --tail 20 | grep https
```

Expected output should show: `Tomcat started on port 8081 (https)`

## Troubleshooting

### Service Won't Start
- Check keystore.p12 files exist in each service's resources folder
- Verify SSL_KEY_STORE_PASSWORD matches in all configurations
- Check Docker logs for SSL-related errors

### Frontend Can't Connect
- Ensure Angular dev server is restarted after proxy changes
- Verify proxy.conf.json is correctly formatted
- Check browser console for mixed content warnings

### Inter-Service Communication Fails
- Verify WebClientConfig is properly configured with InsecureTrustManagerFactory
- Check container network connectivity: `docker exec product-service ping user-service`
- Review service logs for SSL handshake errors
