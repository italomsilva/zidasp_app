# Zidasp App

Aplicativo de gerenciamento de viveiros para aquicultura (camarão e afins). 

## ⚠️ Status de Desenvolvimento (Aviso ao Testador)

O aplicativo encontra-se atualmente em **processo de migração** de dados estáticos para uma conexão real com a nossa API. 

Por conta desse estágio transicional, os dados que você verá na tela estão **mockados** (fakes/simulados localmente), mas os Repositórios da camada de dados já utilizam o `Dio` (cliente HTTP).

### ⏳ Atrasos no Carregamento

Você notará um certo atraso/demora ao carregar as telas ou fazer login. Esse comportamento é **esperado**! Ele ocorre porque o nosso cliente `Dio` tenta realizar a requisição de rede para a API e aguarda um tempo, antes do aplicativo processar o fallback (plano B) utilizando os dados locais presentes no ambiente de Mock.

## 🔐 Como realizar o Login

Para testar o aplicativo e visualizar diferentes permissões (Admin e Empregado), bem como diferentes hierarquias de empresas e viveiros, basta utilizar um dos CPFs abaixo na tela de login.

**Senha:** Para fins de teste, o sistema está mockado para aceitar **qualquer senha desde que possua 8 caracteres ou mais**.

### Usuários de Teste

Utilize qualquer um destes CPFs matematicamente válidos. Não digite a formatação (com pontos e traços), apenas os números:

1. **Joao Silva** (Administrador Completo)
   - **CPF:** `33408456038`
   - **Empresas:** Administrador em 3 empresas.
   - **Viveiros:** Possui acesso visual a 11 viveiros.

2. **Jose Santos** (Perfil Híbrido)
   - **CPF:** `37188712034`
   - **Empresas:** 2 empresas (Administrador em uma, Funcionário/Empregado na outra).
   - **Viveiros:** Possui acesso visual a 7 viveiros.

3. **Renato Oliveira** (Perfil Simples)
   - **CPF:** `30121901041`
   - **Empresas:** Administrador em 1 empresa.
   - **Viveiros:** Possui acesso visual a 2 viveiros.

---

Obrigado por ajudar no processo de testes de front-end do nosso sistema!
