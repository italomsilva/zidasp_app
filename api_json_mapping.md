# Mapeamento de JSON: API vs. Aplicativo (Zidasp)

Este documento descreve a estrutura de dados retornada pela API atual (conforme `api_spec.md`) comparada com a estrutura que o Aplicativo Flutter espera (conforme os `DTOs` e `MockData`).

As colunas **"Uso de Enriquecimento"** indicam campos que o Repositório do App está preenchendo artificialmente via `MockData` para evitar quebras na interface até que a API forneça esses dados.

---

## 1. Usuário (User)
**Endpoint:** `GET /user/:id`

| Campo | API JSON | App DTO (`UserDTO`) | Origem / Observação |
| :--- | :--- | :--- | :--- |
| **ID** | `id` (uuid) | `id` (string) | Direto da API |
| **Nome** | `name` | `name` | Direto da API |
| **Email** | `email` | `email` | Direto da API |
| **Documento** | `document` | `document` | Direto da API |
| **Papel/Role** | ❌ Ausente | `role` (enum) | Enriquecido (`MockData`) |
| **Data Adesão** | ❌ Ausente | `joinDate` | Enriquecido (Data atual) |
| **Total Emp.** | ❌ Ausente | `totalCompanies` | Enriquecido (`MockData`) |
| **Total Viv.** | ❌ Ausente | `totalPonds` | Enriquecido (`MockData`) |
| **Token** | ❌ Ausente | `token` | Gerado no Login Mockado |

---

## 2. Empresa (Company)
**Endpoint:** `GET /company/:id`

| Campo | API JSON | App DTO (`CompanyDTO`) | Origem / Observação |
| :--- | :--- | :--- | :--- |
| **ID** | `id` (uuid) | `id` | Direto da API |
| **Nome** | `name` | `name` | Direto da API |
| **Documento** | `document` | `document` | Direto da API |
| **Total Viv.** | ❌ Ausente | `totalPonds` | Enriquecido (`MockData`) |
| **Viv. Ativos** | ❌ Ausente | `activePonds` | Enriquecido (`MockData`) |
| **Cargo Usuário**| ❌ Ausente | `userRole` | Enriquecido (`MockData`) |

---

## 3. Viveiro (Pond)
**Endpoint:** `GET /pond/:id`

| Campo | API JSON | App DTO (`PondDTO`) | Origem / Observação |
| :--- | :--- | :--- | :--- |
| **ID** | `id` (uuid) | `id` | Direto da API |
| **Nome** | `name` | `name` | Direto da API |
| **ID Empresa** | `company.id` | `companyId` | Mapeado de `json['company']['id']` |
| **Métricas** | ❌ Ausente | `oxygen`, `ph`, `salinity`, etc. | Enriquecido (`MockData`) |
| **Atuadores** | ❌ Ausente | `aeratorsOn`, `pumpsOn`, etc. | Enriquecido (`MockData`) |
| **Alertas** | ❌ Ausente | `hasAlert` | Enriquecido (`MockData`) |
| **Atualização** | ❌ Ausente | `lastUpdate` | Enriquecido (Data atual) |
| **Sensores** | `sensors[]` | `sensors` (List) | IDs da API + Valores de Mock |

---

## 4. Sensores e Atuadores

### Sensores (`SensorDTO`)
- **API:** Retorna apenas metadados fixos (`id`, `hardwareId`, `type`).
- **App:** Além disso, espera `value` (double) e `unity` (string). Atualmente esses valores são injetados via `MockData` no repositório.

### Atuadores (`ActuatorDTO`)
- **API:** Não possui endpoint de listagem explícito para DTO, apenas endpoints de ação (`POST /iot/...`).
- **App:** Espera uma lista de objetos com `id`, `name`, `type`, `active` (bool) e `pondId`. O repositório gera essa lista baseando-se no `MockData` vinculado ao ID do viveiro real.

---

## Resumo Técnico (Estratégia Sênior)

Para manter o aplicativo funcional enquanto o Backend é desenvolvido, os **Repositories** realizam o seguinte fluxo:

1. **Chamada HTTP:** Obtém o objeto fundamental da API (ex: o nome e ID do viveiro).
2. **Busca Local:** Localiza no `MockData.dart` o objeto correspondente usando o `id`.
3. **Merge (Mesclagem):** Cria um novo mapa JSON contendo os campos da API sobrescrevendo os do Mock, garantindo que o `fromJson()` do DTO receba todos os campos necessários.

> [!TIP]
> Caso a API venha a retornar campos como `oxygen` ou `totalPonds` no futuro, o código já está preparado para dar prioridade ao valor que vem do servidor (spread operator: `{...mock, ...api}`).
