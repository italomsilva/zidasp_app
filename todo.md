# Relatório de Inconsistência da API Zidasp (todo.md)

Este documento rastreia as lacunas técnicas entre as expectativas atuais do Frontend (Modelos/DTOs) e o `api_spec.md`.

## 1. Camada de Autenticação
- **Inconsistência:** O `api_spec.md` não define `/login`, `/auth` ou qualquer endpoint de segurança baseado em token. O `UserRepository` do Front-end espera um método `login` que retorne um `token`.
- **Impacto:** A autenticação real é impossível. O aplicativo atualmente "simula" o login encontrando usuários na lista de `GET /user`.
- **Solução Sênior:** Implementar um `AuthModule` no NestJS com `Passport` e `JWT`, expondo `POST /auth/login` que retorne o usuário e um access_token. Refatorar o `UserRepository` no Flutter para armazenar esse token usando `FlutterSecureStorage`.

## 2. Telemetria do Viveiro e Contagens Agregadas
- **Inconsistência:** O `PondDTO` espera métricas em tempo real (`oxigênio`, `temperatura`, `salinidade`, `ph`, `transparência`, `aeradoresLigados`, etc.). O `api_spec.md` retorna apenas metadados (`id`, `nome`, `empresa`, `sensores`).
- **Impacto:** O Dashboard mostraria "0" ou "N/A" para todas as métricas se não fosse enriquecido por dados mockados. 
- **Solução Sênior:** O `GET /pond/:id` deve retornar opcionalmente a `telemetria_atual` de cada sensor associado, ou criar um endpoint `GET /pond/:id/status` que resuma o estado atual do hardware (ligado/desligado) e os últimos valores lidos.

## 3. Metadados de Usuário e Empresa
- **Inconsistência:** `UserDTO` e `CompanyDTO` esperam campos agregados como `totalEmpresas`, `totalViveiros` e `viveirosAtivos`. Estes estão ausentes nas respostas do `api_spec.md`.
- **Impacto:** As páginas de Perfil e de Listagem de Empresas perdem informações de resumo cruciais para a experiência do usuário.
- **Solução Sênior:** Adicionar campos virtuais/contadores calculados no backend TypeORM para retornar `contagem_viveiros` nas listagens de empresa e `contagem_empresas` no perfil do usuário.

## 4. Mapeamento de Dispositivos Atuadores
- **Inconsistência:** O Front-end usa um `deviceId` genérico para `toggleDevice`, enquanto a API define endpoints específicos para atuadores de `oxigênio` e `salinidade`.
- **Impacto:** Desconexão entre a ação da UI e o endpoint correto da API.
- **Solução Sênior:** Refatorar a entidade `Actuator` no Front para carregar explicitamente o `tipo` (Oxygen|Salinity) para que o Repository saiba exatamente qual endpoint chamar, evitando mapeamentos manuais baseados em strings estáticas.
