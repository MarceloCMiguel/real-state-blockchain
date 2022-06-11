
# Dicionário que indica quanto o usuário sacou de dividendos
users_withdraw: public(HashMap[address, uint256])
# Dicionario que indica número de cotas do usuário
users_num_cota: public(HashMap[address,uint256])
# Valor da cota
patrimonio: uint256

# Endereço do dono do contrato
owner: address

# Número máximo de tickets
total_tickets: uint256
# Número de tickets emitidos
count: uint256

div_cota: uint256

sell_price: uint256

end: bool

balanco_atual: uint256
# Função que roda quando é feito o deploy do contrato
# IPO
@external
def __init__(price: uint256, total_tickets: uint256):
    # Guarda o Endereço do dono do contrato na variável
    self.owner = msg.sender
    self.patrimonio = price
    self.total_tickets = total_tickets
    self.count = total_tickets
    self.div_cota = 0
    self.balanco_atual = 0
    self.end = False
    self.sell_price = (self.patrimonio / self.total_tickets)*80/100

@external
@payable
def buy(num_buy:uint256 ):

    # verifica se ainda não foi feito o OPA
    assert self.end == False

        # verifica se há o número de cotas necessário
    assert self.count >= num_buy

    # verifica se valor depositado é maior ou igual ao valor pedido
    assert msg.value >= num_buy*(self.patrimonio/self.total_tickets)

    # desconta do contrato o número de cotas
    self.count -= num_buy

    #atualiza balanço do contrato (variavel que considera apenas compras e vendas)
    self.balanco_atual+= num_buy * (self.patrimonio/self.total_tickets)
    
    # adiciona cotas para o usuário
    self.users_num_cota[msg.sender] += num_buy
    
    # adiciona withdraw pelo div_cota atual
    self.users_withdraw[msg.sender] += num_buy* self.div_cota


@external
@payable
def deposity_div():
    # confirma que é o owner
    assert msg.sender == self.owner
    
    # adiciona div_cota
    self.div_cota += msg.value/self.total_tickets
    

@external
def sacar():
    # envia dinheiro para o cotista
    send(msg.sender, self.users_num_cota[msg.sender]*self.div_cota - self.users_withdraw[msg.sender])

    #atualiza seu histórico de saque
    self.users_withdraw[msg.sender] += self.div_cota * self.users_num_cota[msg.sender]


@external
def sell(num_cotas:uint256):

    # Verifica se ainda não foi feito o OPA
    assert self.end == False

    # verifica se o cotista possui cotas necessárias a serem vendidas
    assert num_cotas <= self.users_num_cota[msg.sender]
    
    # Envia possíveis dividendos para o cotista referente a cota vendida
    send(msg.sender,(num_cotas * self.patrimonio * 80 /(self.total_tickets*100)) + ((self.div_cota*self.users_num_cota[msg.sender]-self.users_withdraw[msg.sender])/self.users_num_cota[msg.sender])* num_cotas )
    
    # Atualiza seu withdraw
    self.users_withdraw[msg.sender] = (self.users_withdraw[msg.sender] / self.users_num_cota[msg.sender]) * (self.users_num_cota[msg.sender] - num_cotas)
    
    # envia 80% do valor das cotas para o cotista
    # send(msg.sender, num_cotas * self.patrimonio /self.total_tickets)
    
    # Atualiza balanço
    self.balanco_atual -= num_cotas* (self.patrimonio/self.total_tickets)
    
    # Atualiza cotas do cotista
    self.users_num_cota[msg.sender] -= num_cotas

    # Atualiza números de cotas do contrato
    self.count += num_cotas
    

@external
def opa():
    assert self.count == 0
    assert self.end == False

    self.end = True
    send(self.owner, self.balanco_atual)

