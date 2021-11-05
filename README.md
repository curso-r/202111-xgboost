
## Configuração: Criar um projeto do RStudio

Faça um projeto do RStudio para usar durante todo o curso. O código
abaixo irá fazer isso para você.

``` r
install.packages("usethis")
usethis::create_project("xgboost202111")
```

## Configuração: Instalar pacotes

``` r
install.packages('tidyverse')
install.packages('tidymodels')
install.packages('rmarkdown')
install.packages('knitr')
install.packages('ISLR')
install.packages('xgboost')
install.packages('pROC')
install.packages('vip')
install.packages('modeldata')
install.packages('usemodels')
install.packages('tidypredict')
```

## Dúvidas

Fora do horário de aula ou monitoria:

-   perguntas gerais sobre o curso deverão ser feitas no Classroom.

-   perguntas sobre R, principalmente as que envolverem código, deverão
    ser enviadas no [nosso fórum](https://discourse.curso-r.com/).

## Slides

| slide                                | link                                                                                 |
|:-------------------------------------|:-------------------------------------------------------------------------------------|
| xgboost_teoria_e\_passo_a\_passo.pdf | <https://curso-r.github.io/202111-xgboost/slides/xgboost_teoria_e_passo_a_passo.pdf> |
| xgboost.html                         | <https://curso-r.github.io/202111-xgboost/slides/xgboost.html>                       |

## Referências externas

#### Machine Learning

-   [Introduction to Statistical Learning (Hastie, et
    al)](https://web.stanford.edu/~hastie/ISLRv2_website.pdf)
-   [Elements of Statistical Learning (Hastie, et
    al)](https://web.stanford.edu/~hastie/Papers/ESLII.pdf)
-   [Computer Age Statistical Inference (Hastie,
    Efron)](https://web.stanford.edu/~hastie/CASI_files/PDF/casi.pdf)
-   [Tidymodels (Kuhn, et al)](https://www.tidymodels.org/)
-   [Tidy Modeling With R](https://www.tmwr.org/)
-   [XGBoost - Documentação
    oficial](https://xgboost.readthedocs.io/en/latest/tutorials/model.html)
-   [Feature Engineering and Selection: A Practical Approach for
    Predictive Models (Kuhn, Kjell)](http://www.feat.engineering/)
-   [Kaggle](https://www.kaggle.com/)

#### Programação em R

-   [Livro da Curso-R (Curso-R)](https://livro.curso-r.com/)
-   [Tidyverse (Wickham H)](https://www.tidyverse.org/)
-   [R for Data Science (Wickham H)](https://r4ds.had.co.nz/)
-   [Advanced R (Wickham H)](https://adv-r.hadley.nz/)

#### Miscelânea

-   [Tidytext (Silges, et al)](https://www.tidytextmining.com/)
-   [Tabnet model (Falbel)](https://mlverse.github.io/tabnet/)
-   [Forecasting: Principles and Practive (Hyndman,
    Athanasopoulos)](https://otexts.com/fpp3/)

## Redes sociais da Curso-R

Youtube: <https://www.youtube.com/c/CursoR6/featured>

Instagram: <https://www.instagram.com/cursoo_r/>

Twitter: <https://twitter.com/curso_r>

Linkedin: <https://www.linkedin.com/company/curso-r/>

Facebook: <https://www.facebook.com/cursodeR>

``` r
# Criar arquivo _config.yml
if(params$download_material == TRUE){
 glue::glue('theme: jekyll-theme-minimal', '\n',
    "logo: assets/logo.png", '\n',
    "title: {params$nome_curso}", '\n',
    "show_downloads: true", '\n',
    "link_material: 'https://github.com/curso-r/{params$main_repo}/raw/master/material_do_curso.zip'", '\n'
    
    ) %>%
    readr::write_lines( "_config.yml")
}

if(params$download_material == FALSE){
  glue::glue('theme: jekyll-theme-minimal', '\n',
    "logo: assets/logo.png", '\n',
    "title: {params$nome_curso}", '\n',
    "show_downloads: false", '\n') %>%
    readr::write_lines( "_config.yml")
}
```
