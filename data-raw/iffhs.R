## code to prepare `iffhs` dataset goes here


library(httr) #paralelo do request de python

tabelas <- GET("https://en.wikipedia.org/wiki/List_of_footballers_with_500_or_more_goals") |>
    content() |>
    rvest::html_table() #rvest eh paralelo ao beautifulsoup do python

iffhs <- tabelas |> 
    purrr::pluck(2) |>
    janitor::row_to_names(1) |>
    #dplyr::glimpse()
    janitor::clean_names() |> #daqui para baixo é faxina de dados
    dplyr::select(
        rank, player, league, cup, continental, 
        country = dplyr::starts_with("mw"),
        total, career_span
    ) |>
    dplyr::mutate(
        player = stringr::str_remove(player, "\\*"),
        dplyr::across(
            c(league, cup, continental, country, total),
            readr::parse_number
        )
    )

#fluxo de criações de um script, funções e documentação
usethis::create_package("C:/Users/arnch/OneDrive/Documentos/criandoPacotesR")
usethis::use_data_raw("iffhs")  
devtools::document() # depois de documentar função rodar isso e essa função registra funcao documentada no arquivo feio que R pede dentro de uma pasta man (que eh criada qnd roda isso). dps desse comando consigo usar o help da funçao e posso rodar de novo este comando para reescrever com atualizações

usethis::use_data(iffhs, overwrite = TRUE) #se eu instalar este pacote e der library nele (library(criandoPacotesR)), eu consigo acessar este dataset> devo rodar no terminal R este codigo e o data set vai aparecer na pasta data e estara disponivel. só precisa documentar o data set

#criar na pasta R um arquivo chamado utils-data.R para documentar base de dados (tem regra de como documentar base de dados)
# depois de formatar a(s) base(s) rodas o comando no terminal R: 
devtools::document() #para documentar a base de dados 
#dps disso da pra abrir o help dela: 
?iffhs

usethis::use_mit_license() # para colocar a licensa MIT no pacote

devtools::check() # para verificar se tem algum erro no pacote ou se esqueci de algo
usethis::use_package("dplyr") # inclui em imports da description as bibliotecas que meu pacote dependem
# fazer para 'dplyr' 'httr' 'janitor' 'purrr' 'readr' 'rvest' 'stringr'
usethis::use_package("dplyr")
usethis::use_package("httr")
usethis::use_package("janitor")
usethis::use_package("purrr")
usethis::use_package("readr")
usethis::use_package("rvest")
usethis::use_package("stringr")
#criar em R um arquivo chamado utils-globals.R
# registra variaveis como globais e acaba com a note que reclama disso (há uma discussão se precisa ou n fazer isso)

# salvar em um repositorio no github para alguem conseguir instalar:
usethis::use_git() #precisa ter git instalado e ele precisa estar no meu path
# escolher opção 3 # para comitar eles e depois reinicia sessão do R
usethis::use_github() #cria um repositorio na minha conta, escolho pelo parametro se é publico ou privado e ja deixa todos os arquivos lá

remotes::install_github("arnaldochebl/criandoPacotesR") #instala o pacote que criei a partir do repositorio do github
# apartei 3 depois para nao fzr update de nenhum...

#usa pacote criado
library(criandoPacotesR)
iffhs

# o github actions usa uma maquina virtual do proprio github que ate alguns minutos por  mes é gratis
usethis::use_readme_rmd() #cria arquivo readme.Rmd
usethis::use_github_action_check_standard() # adiciona umas badges no readme
# editar arquivo readme
#fazer o knit do readme (vai ccriar .md e .html)
# o comando action de cima tbm cria uma pasta .github com um arquivo de workflow que é um arquivo de configuracao do github actions