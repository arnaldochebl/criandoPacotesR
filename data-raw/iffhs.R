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
# usethis::create_package("C:/Users/arnch/OneDrive/Documentos/criandoPacotesR")
# usethis::use_data_raw("iffhs")  
# devtools::document()  depois de documentar função rodar isso e essa função registra funcao documentada no arquivo feio que R pede dentro de uma pasta man (que eh criada qnd roda isso). dps desse comando consigo usar o help da funçao e posso rodar de novo este comando para reescrever com atualizações
#criar na pasta R um arquivo chamado utils-data.R para documentar base de dados (tem regra de como documentar base de dados)
# depois de formatar a(s) base(s) rodas o comando no terminal R: devtools::document() para documentar a base de dados 
#dps disso da pra abrir o help dela: ?iffhs
# usethis::use_mit_license() para colocar a licensa MIT no pacote
# devtools::check() para verificar se tem algum erro no pacote ou se esqueci de algo
# usethis::use_package("dplyr") # inclui em imports da description as bibliotecas que meu pacote dependem
# fazer para 'dplyr' 'httr' 'janitor' 'purrr' 'readr' 'rvest' 'stringr'
#usethis::use_package("dplyr")
#usethis::use_package("httr")
#usethis::use_package("janitor")
#usethis::use_package("purrr")
#usethis::use_package("readr")
#usethis::use_package("rvest")
#usethis::use_package("stringr")
#criar em R um arquivo chamado utils-globals.R
# registra variaveis como globais e acaba com a note que reclama disso (há uma discussão se precisa ou n fazer isso)


#salvar estes dados de forma que outra pessoa que instalar este pacote possa usar
# criar uma função que faça este tratamento

usethis::use_data(iffhs, overwrite = TRUE) #se eu instalar este pacote e der library nele (library(criandoPacotesR)), eu consigo acessar este dataset> devo rodar no terminal R este codigo e o data set vai aparecer na pasta data e estara disponivel. só precisa documentar o data set
