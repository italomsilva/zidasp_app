# API Endpoints - zidasp

Este documento lista todos os endpoints HTTP e tópicos MQTT do projeto, com entrada, saída e descrição.

## Base URL

- local: `http://localhost:3000/`
- seja coerente com `api` do docker-compose.

---

## 1. Company

`/company`

1. `POST /company`
   - descrição: criar empresa
   - request JSON:
     {
       "name": "Empresa XYZ",
       "document": "12345678000100",
       "userId": "uuid-user"
     }
   - response JSON:
     {
       "id": "uuid-company",
       "name": "Empresa XYZ",
       "document": "12345678000100",
       "members": [],
       "ponds": []
     }

2. `GET /company`
   - descrição: listar todas empresas
   - request: nenhum
   - response JSON:
     [
       {
         "id": "uuid-company",
         "name": "Empresa XYZ",
         "document": "12345678000100"
       }
     ]

3. `GET /company/:id`
   - descrição: obter empresa por id
   - path param: `id` (uuid)
   - response JSON:
     {
       "id": "uuid-company",
       "name": "Empresa XYZ",
       "document": "12345678000100"
     }

4. `PATCH /company/:id`
   - descrição: atualizar empresa
   - path param: `id` (uuid)
   - request JSON:
     {
       "name": "Empresa XYZ Atualizada",
       "document": "12345678000100"
     }
   - response JSON:
     {
       "id": "uuid-company",
       "name": "Empresa XYZ Atualizada",
       "document": "12345678000100"
     }

5. `DELETE /company/:id`
   - descrição: remover empresa
   - path param: `id` (uuid)
   - response JSON:
     {
       "affected": 1
     }

---

## 2. Pond

`/pond`

1. `POST /pond`
   - descrição: criar viveiro
   - request JSON:
     {
       "name": "Viveiro A",
       "companyId": "uuid-company"
     }
   - response JSON:
     {
       "id": "uuid-pond",
       "name": "Viveiro A",
       "company": { /* company info */ },
       "sensors": []
     }

2. `GET /pond`
   - descrição: listar todos viveiros
   - response JSON:
     [
       {
         "id": "uuid-pond",
         "name": "Viveiro A",
         "company": { /* company info */ }
       }
     ]

3. `GET /pond/:id`
   - descrição: obter viveiro por id
   - response JSON:
     {
       "id": "uuid-pond",
       "name": "Viveiro A",
       "company": { /* company info */ }
     }

4. `PATCH /pond/:id`
   - descrição: atualizar viveiro
   - request JSON:
     {
       "name": "Viveiro A Atualizado"
     }
   - response JSON:
     {
       "id": "uuid-pond",
       "name": "Viveiro A Atualizado"
     }

5. `DELETE /pond/:id`
   - descrição: remover viveiro
   - response JSON:
     {
       "affected": 1
     }

---

## 3. Sensor

`/sensor`

1. `POST /sensor`
   - descrição: criar sensor
   - request JSON:
     {
       "hardwareId": "HW123",
       "type": "Oxygen",
       "pondId": "uuid-pond"
     }
   - response JSON:
     {
       "id": "uuid-sensor",
       "hardwareId": "HW123",
       "type": "Oxygen",
       "pond": { /* pond info */ }
     }

2. `GET /sensor/pond/:pondId`
   - descrição: listar sensores no viveiro
   - response JSON:
     [
       {
         "id": "uuid-sensor",
         "hardwareId": "HW123",
         "type": "Oxygen"
       }
     ]

3. `GET /sensor/:id`
   - descrição: obter sensor por id
   - response JSON:
     {
       "id": "uuid-sensor",
       "hardwareId": "HW123",
       "type": "Oxygen"
     }

4. `PATCH /sensor/:id`
   - descrição: atualizar sensor
   - request JSON:
     {
       "hardwareId": "HW1234",
       "type": "Salinity"
     }
   - response JSON:
     {
       "id": "uuid-sensor",
       "hardwareId": "HW1234",
       "type": "Salinity"
     }

5. `DELETE /sensor/:id`
   - descrição: remover sensor
   - response JSON:
     {
       "affected": 1
     }

---

## 4. User

`/user`

1. `POST /user`
   - descrição: criar usuário
   - request JSON:
     {
       "name": "João",
       "email": "joao@example.com",
       "document": "12345678900",
       "password": "senha123"
     }
   - response JSON:
     {
       "id": "uuid-user",
       "name": "João",
       "email": "joao@example.com",
       "document": "12345678900"
     }

2. `GET /user`
   - descrição: listar usuários
   - response JSON:
     [
       {
         "id": "uuid-user",
         "name": "João",
         "email": "joao@example.com",
         "document": "12345678900"
       }
     ]

3. `GET /user/:id`
   - descrição: obter usuário por id
   - response JSON:
     {
       "id": "uuid-user",
       "name": "João",
       "email": "joao@example.com",
       "document": "12345678900"
     }

4. `PATCH /user/:id`
   - descrição: atualizar usuário
   - request JSON:
     {
       "name": "João Silva",
       "email": "joao.silva@example.com",
       "document": "12345678900"
     }
   - response JSON:
     {
       "id": "uuid-user",
       "name": "João Silva",
       "email": "joao.silva@example.com",
       "document": "12345678900"
     }

5. `DELETE /user/:id`
   - descrição: remover usuário
   - response JSON:
     {
       "affected": 1
     }

---

## 5. IoT (MQTT + HTTP de atuadores)

### 5.1 Tópicos MQTT assinados (consumer)

1. `iot/pond/+/oxygen/sensor`
   - descrição: recebe valor de oxigênio do sensor (payload texto numérico)
   - payload: `"7.2"`
   - processing: `IotService.saveOxygenTelemetry(pondId, 7.2)`
   - response: consumer sem body

2. `iot/pond/+/salinity/sensor`
   - descrição: recebe valor de salinidade do sensor
   - payload: `"35.0"`
   - processing: `IotService.saveSalinityTelemetry(pondId, 35.0)`

### 5.2 Endpoints HTTP de atuadores

1. `POST /iot/pond/:pondId/oxygen/actuator?power=ON|OFF`
   - descrição: liga/desliga aerador do viveiro
   - request: nenhum corpo, query `power=ON` ou `power=OFF`
   - response JSON:
     {
       "sucess": true
     }
   - status: `201`

2. `POST /iot/pond/:pondId/salinity/actuator?power=ON|OFF`
   - descrição: liga/desliga bomba de salinidade do viveiro
   - response JSON:
     {
       "sucess": true
     }
   - status: `201`

### 5.3 Endpoints de documentação MQTT

1. `HEAD /iot/pond/:pondId/oxygen/sensor`
   - usado para documentar no Swagger
   - response: sem corpo

2. `HEAD /iot/pond/:pondId/salinity/sensor`
   - usado para documentar no Swagger
   - response: sem corpo

---

## Observações

- A API não descreve explicitamente no controller o schema de resposta, mas seguem as entidades TypeORM (Company, Pond, Sensor, User).
- `password` em `User` está marcado `select: false`, ou seja, não retorna normalmente.
- Enum `SensorTypeEnum` definido em `api/src/modules/management/domain/enums/sensorType.enum.ts` e `api/src/modules/iot/domain/enums/sensorType.enum.ts`.
- Enum `PowerEnum` em `api/src/modules/iot/domain/enums/power.enum.ts`.

---

## Referências de DTOs

- `CreateCompanyDto`: `{ name, document, userId }`
- `UpdateCompanyDto`: `{ name?, document? }`
- `CreatePondDto`: `{ name, companyId }`
- `UpdatePondDto`: `{ name? }`
- `CreateSensorDto`: `{ hardwareId, type, pondId }`
- `UpdateSensorDto`: `{ hardwareId?, type? }`
- `CreateUserDto`: `{ name, email, document, password }`
- `UpdateUserDto`: `{ name?, email?, document? }`

