
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

    assert self.end == False

    # verifica se valor depositado é maior que o valor de uma cota
    assert msg.value >= num_buy*(self.patrimonio/self.total_tickets)

    # número de cotas que o usuário consegue comprar
    assert self.count >= num_buy
    self.count -= num_buy

    self.balanco_atual+= num_buy * (self.patrimonio/self.total_tickets)
    self.users_num_cota[msg.sender] += num_buy
    self.users_withdraw[msg.sender] += num_buy* self.div_cota


@external
@payable
def deposity_div():
    assert msg.sender == self.owner
    self.div_cota += msg.value/self.total_tickets
    

@external
def sacar():
    # envia dinheiro para o cotista
    send(msg.sender, self.users_num_cota[msg.sender]*self.div_cota - self.users_withdraw[msg.sender])

    #atualiza seu histórico de saque
    self.users_withdraw[msg.sender] += self.div_cota * self.users_num_cota[msg.sender]


@external
def sell(num_cotas:uint256):

    assert self.end == False

    assert num_cotas <= self.users_num_cota[msg.sender]
    # Envia possíveis dividendos para o vendedor referente a cota vendida
    send(msg.sender,((self.div_cota*self.users_num_cota[msg.sender]-self.users_withdraw[msg.sender])/self.users_num_cota[msg.sender])* num_cotas)
    self.users_withdraw[msg.sender] = (self.users_withdraw[msg.sender] / self.users_num_cota[msg.sender]) * (self.users_num_cota[msg.sender] - num_cotas)
    
    # envia 80% do valor das cotas para o dono
    send(msg.sender, (80/100)*num_cotas * self.patrimonio /self.total_tickets)
    self.balanco_atual -= num_cotas* (self.patrimonio/self.total_tickets)
    
    
    
    self.users_num_cota[msg.sender] -= num_cotas

    self.count += num_cotas
    

@external
def opa():
    assert self.count == 0
    assert self.end == False

    self.end = True
    send(self.owner, self.balanco_atual)

