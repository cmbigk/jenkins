package com.ecommerce.productservice.config;

import io.netty.handler.ssl.SslContext;
import io.netty.handler.ssl.SslContextBuilder;
import io.netty.handler.ssl.util.InsecureTrustManagerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.netty.http.client.HttpClient;

import javax.net.ssl.SSLException;

@Configuration
public class WebClientConfig {
    
    @Bean
    public WebClient.Builder webClientBuilder() {
        try {
            // Configure SSL context to accept self-signed certificates
            SslContext sslContext = SslContextBuilder
                    .forClient()
                    .trustManager(InsecureTrustManagerFactory.INSTANCE)
                    .build();
            
            HttpClient httpClient = HttpClient.create()
                    .secure(sslSpec -> sslSpec.sslContext(sslContext));
            
            return WebClient.builder()
                    .clientConnector(new ReactorClientHttpConnector(httpClient));
        } catch (SSLException e) {
            // Fallback to default if SSL configuration fails
            return WebClient.builder();
        }
    }
}
