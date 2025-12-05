#import "@preview/typslides:1.3.0": *
// #set text("pt-BR")
#show: typslides.with(
  ratio: "16-9",
  theme: "greeny",
  font: "Fira Sans",
  font-size: 20pt,
  link-style: "color",
  show-progress: true,
)


#front-slide(
  title: "Tarefas e Processos em Sistemas Operacionais",
  authors: "Lucas Silva de Oliveira",
  info: [Bacharel em Sistemas de Informação],
)

// ----------------------------------------------------------
// SUMÁRIO
// ----------------------------------------------------------

#table-of-contents()

// SLIDE 1 — Programa vs Tarefa
// ----------------------------------------------------------

#title-slide[
  O Contexto Inicial: Programa vs. Tarefa
]

#slide[
  - #stress("O que é um Programa?")
    - Conceito estático.
    - Arquivo no disco com instruções passivas (ex: `browser.exe`).
    - *Receita de bolo* escrita no papel.  

  - #stress("O que é uma Tarefa (Task)?")
    - Conceito dinâmico.
    - A execução sequencial de instruções com uma finalidade.
    - Possui estado interno que muda ao longo do tempo.
    - O ato de *cozinhar* seguindo a receita.
]

// ----------------------------------------------------------
// SLIDE 2 — De Tarefa para Processo
// ----------------------------------------------------------

#title-slide[
  De Tarefa para Processo
]

#slide[
  - #stress("Como o SO gerencia Tarefas?")
    - Ele precisa criar um ambiente completo para executá-las.

  - #stress("Conceito de Processo")
    - É a forma como o SO implementa e isola uma tarefa.
    - Processo = **contêiner de recursos**.
    - Agrupa tudo o que a tarefa precisa: memória, arquivos, contexto de hardware.

  - #stress("Evolução")
    - Antigamente: *1 processo = 1 tarefa*.
    - Hoje: *1 processo pode conter várias tarefas* (threads).

  #framed(title: "Pra entender melhor - 1")[
    Segundo @tanenbaum2015, o computador não executa arquivos, mas sim fluxos de instruções.
    Uma receita é o programa, o cozinheiro é o processamento (CPU) e os ingredientes são os dados de entrada. O processo é a atividade do cozinheiro ler a receita, buscar os ingredientes e preparo da receita pelo cozinheiro.
  ]

  #framed(title: "Pra entender melhor - 2")[
    O processo é a “caixa” que isola a tarefa para que ela
    não interfira em outras. Ele é o mecanismo do Sistema Operacional para encapsular execução.
  ]
]

// ----------------------------------------------------------
// SLIDE 3 — Ciclo de Vida
// ----------------------------------------------------------

#title-slide[
  Gerência de Tarefas
]

#slide[
  - O processador tem de executar todas as tarefas submetidas pelos usuários. Essas tarefas geralmente têm comportamento, duração e importância distintas. Cabe ao sistema operacional organizar as tarefas para executá-las e decidir em que ordem fazê-lo @maziero2019.
  
  - #stress("Sistemas Monotarefas")
    - Anos 40.
    - Executa uma tarefa por vez.
    - Cada binário era carregado do disco para a memória e executado até o fim.
    - Os dados de entrada da tarefa eram carregados na memória junto à mesma e os resutados obtidos eram escritos no disco após a conclusão da tarefa.
    - Todas as operações de transferência de código e dados entre o disco e a memória eram coordenados por um operador humano.
    - Simples, mas ineficiente (CPU ociosa durante I/O).

  #figure(
    image("img/estado-monotarefa.png", width: 50%),
    caption: [
      Estados de uma tarefa em um sistema monotarefa.\  
      _Adaptado de @maziero2019 (2019)._
    ]
  )

  - #stress("Sistemas Multitarefas")
    - Descompasso significativo entre a alta velocidade de processamento e a baixa velocidade dos dispositivos de entrada/saída, o que deixava o processador ocioso durante transferências de dados.
    - O monitor de sistema operacional foi introduzido para gerenciar múltiplas tarefas.
    - Suspender tarefas que aguardam I/O para permitir que outras sejam executadas.
    - Passar o processador para outra tarefa pronta para execução.
    - Permitia que o processador fosse compartilhado entre várias tarefas, alternando entre elas conforme necessário.
     
  #figure(
    image("img/estado-multitarefa.png", width: 85%),
    caption: [
      Diagrama de estados de uma tarefa em um sistema multitarefas.\  
      _Adaptado de @maziero2019 (2019)._
    ]
  )

  - #stress("Sistemas de Tempo Compartilhado")
    - O processador é dividido em pequenos intervalos de tempo (quantum).
    - Cada tarefa recebe um quantum para executar antes de ser interrompida (Preempção) e passar o processador para outra tarefa.
    - A implementação depende de um temporizador programável no hardware, que gera interrupções periódicas (chamadas de ticks). Essas interrupções devolvem o controle ao núcleo do sistema operacional regularmente.
    - Quando uma tarefa assume o processador, o núcleo define um contador de ticks (baseado no quantum). A cada interrupção do relógio, o contador é decrementado. Se chegar a zero, a tarefa sofre preempção.
    - Cria a ilusão de multitarefa real, onde várias tarefas parecem ser executadas ao mesmo tempo.

  #figure(
    image("img/estado-compartilhado.png", width: 100%),
    caption: [
      Diagrama de estados de uma tarefa em um sistema de tempo compartilhado.\  
      _Adaptado de @maziero2019 (2019)._
    ]
  )
]



// ----------------------------------------------------------
// SLIDE 4 — Troca de Contexto
// ----------------------------------------------------------

#title-slide[
  Troca de Contexto (Context Switch)
]

#slide[
  - #stress("Definição:")
    - Para suspender uma tarefa e retomar outra, o SO deve salvar e restaurar seu contexto. O contexto diz respeito a estado atual de uma tarefa: registradores, variáveis, contador de programa, stack pointer etc.

  - #stress("Mecanismo:")
    1. Salvar contexto, o associando a um descritor, uma estrutura de dados no núcleo do SO que se chama TCB(Task Control Block).
    2. Escalonador escolhe próxima tarefa.
    3. Restaurar contexto no processador.

  - #stress("Custo:")
    - Consome tempo do processador → overhead.

  #figure(
    image("img/task-control-block.png", width: 50%),
    caption: [
      Structure of the Task Control Block.\  
      _Fonte: @han2021. (2025)._
    ]
  )
]

// ----------------------------------------------------------
// SLIDE 5 — Estrutura do Processo
// ----------------------------------------------------------

#title-slide[
  A Estrutura do Processo (O Contêiner)
]

#slide[
  - O processo é o contêiner que agrupa todos os recursos necessários para a execução de uma ou mais tarefas.
  - #stress("O que há dentro de um Processo?")
    1. Espaço de Endereçamento → código, dados, pilha.
    2. Contexto de Hardware → registradores (PC, SP...).
    3. Recursos do Núcleo → arquivos abertos, conexões etc.
 
  - Os processos são isolados entre si pelos mecanismos de proteção providos pelo hardware (isolamento de áreas de memória, níveis de operação e chamadas de sistema), impedindo que uma tarefa do processo p|a acesse um recurso atribuído ao processo p|b .
 
  - Um processo pode conter múltiplas tarefas (threads) que compartilham o mesmo espaço de endereçamento e recursos, mas possuem seus próprios contextos de hardware.

  #framed(title: "Pra entender melhor - 3")[
    O núcleo do sistema operacional mantém descritores de processos, denominados PCBs (Process Control Blocks), para armazenar as informações referentes aos processos ativos. Um PCB contém informações como o identificador do processo (PID – Process IDentifier), seu usuário, prioridade, data de início, caminho do arquivo contendo o código executado pelo processo, áreas de memória em uso, arquivos abertos, etc
  ]
]


// ----------------------------------------------------------
// SLIDE 6 — Conclusão
// ----------------------------------------------------------

#title-slide[
  Conclusão
]

#slide[
  - #stress("Resumo:")
    - Tarefa → fluxo dinâmico de execução.
    - Processo → contêiner que provê recursos e isolamento.
    - Estados → Pronta, Executando, Suspensa.
    - Context Switch → permite multitarefa real.

  - #stress("Importância:")
    - Gerência eficiente mantém o sistema responsivo e estável.
]


// Bibliography
#let bib = bibliography("bibliography.bib")
#bibliography-slide(bib)
