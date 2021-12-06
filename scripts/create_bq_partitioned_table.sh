# Hard-coded to build the table 'afastamentos_civis'
bq --project_id=gabinete-compartilhado load --source_format=CSV --skip_leading_rows=1 --hive_partitioning_mode=AUTO --hive_partitioning_source_uri_prefix=gs://brutos-publicos/executivo/federal/servidores/partitioned/ executivo_federal_servidores.afastamentos_civis gs://brutos-publicos/executivo/federal/servidores/partitioned/*_Afastamentos_cleaned.csv ano:INTEGER,mes:INTEGER,id_servidor:INTEGER,cpf:STRING,nome:STRING,data_inicio_afastamento:STRING,data_fim_afastamento:STRING

# Hard-coded to build the table 'cadastro_civis'
bq --project_id=gabinete-compartilhado load --source_format=CSV --skip_leading_rows=1 --hive_partitioning_mode=AUTO --hive_partitioning_source_uri_prefix=gs://brutos-publicos/executivo/federal/servidores/partitioned/ executivo_federal_servidores.cadastro_civis gs://brutos-publicos/executivo/federal/servidores/partitioned/*_Cadastro_cleaned.csv mes:INTEGER,ano:INTEGER,id_servidor:INTEGER,nome:STRING,cpf:STRING,matricula:STRING,desc_cargo:STRING,classe_cargo:STRING,ref_cargo:INTEGER,padrao_cargo:STRING,nivel_cargo:INTEGER,sigla_funcao:STRING,nivel_funcao:STRING,funcao:STRING,cod_atividade:STRING,atividade:STRING,opcao_parcial:STRING,cod_uorg_lotacao:STRING,uorg_lotacao:STRING,cod_org_lotacao:STRING,org_lotacao:STRING,cod_orgsup_lotacao:STRING,orgsup_lotacao:STRING,cod_uorg_exercicio:STRING,uorg_exercicio:STRING,cod_org_exercicio:STRING,org_exercicio:STRING,cod_orgsup_exercicio:STRING,orgsup_exercicio:STRING,tipo_vinculo:INTEGER,situacao_vinculo:STRING,inicio_afastamento:STRING,termino_afastamento:STRING,regime_juridico:STRING,jornada_de_trabalho:STRING,ingresso_cargo_funcao:STRING,nomeacao_cargo_funcao:STRING,ingresso_orgao:STRING,doc_ingresso_servico_publico:STRING,data_dipl_ingresso_servico_publico:STRING,dipl_ingresso_cargo_funcao:STRING,dipl_ingresso_orgao:STRING,dipl_ingresso_servico_publico:STRING,uf_exercicio:STRING

# Hard-coded to build the table 'servidores_federais_civis_cadastro' in dataset 'views_publicos'
bq --project_id=gabinete-compartilhado load --source_format=CSV --skip_leading_rows=1 --hive_partitioning_mode=AUTO --hive_partitioning_source_uri_prefix=gs://brutos-publicos/executivo/federal/servidores/partitioned/ views_publicos.servidores_federais_civis_cadastro gs://brutos-publicos/executivo/federal/servidores/partitioned/*_Cadastro_cleaned.csv mes:INTEGER,ano:INTEGER,id_servidor:INTEGER,nome:STRING,cpf:STRING,matricula:STRING,desc_cargo:STRING,classe_cargo:STRING,ref_cargo:INTEGER,padrao_cargo:STRING,nivel_cargo:INTEGER,sigla_funcao:STRING,nivel_funcao:STRING,funcao:STRING,cod_atividade:STRING,atividade:STRING,opcao_parcial:STRING,cod_uorg_lotacao:STRING,uorg_lotacao:STRING,cod_org_lotacao:STRING,org_lotacao:STRING,cod_orgsup_lotacao:STRING,orgsup_lotacao:STRING,cod_uorg_exercicio:STRING,uorg_exercicio:STRING,cod_org_exercicio:STRING,org_exercicio:STRING,cod_orgsup_exercicio:STRING,orgsup_exercicio:STRING,tipo_vinculo:INTEGER,situacao_vinculo:STRING,inicio_afastamento:STRING,termino_afastamento:STRING,regime_juridico:STRING,jornada_de_trabalho:STRING,ingresso_cargo_funcao:STRING,nomeacao_cargo_funcao:STRING,ingresso_orgao:STRING,doc_ingresso_servico_publico:STRING,data_dipl_ingresso_servico_publico:STRING,dipl_ingresso_cargo_funcao:STRING,dipl_ingresso_orgao:STRING,dipl_ingresso_servico_publico:STRING,uf_exercicio:STRING

# Hard-coded to build the EXTERNAL TABLE 'dou_bruto' in dataset 'views_publicos' 
bq --project_id=gabinete-compartilhado mkdef --noautodetect --source_format=NEWLINE_DELIMITED_JSON --hive_partitioning_mode=CUSTOM --hive_partitioning_source_uri_prefix=gs://brutos-publicos/executivo/federal/dou-partitioned/{part_data_pub:DATE}/{part_secao:STRING} views_publicos.dou_bruto gs://brutos-publicos/executivo/federal/dou-partitioned/*.json api_url:STRING,capture_date:TIMESTAMP,url:STRING,url_certificado:STRING,key:STRING,value:STRING > table_definition_files/dou_bruto.json
bq --project_id=gabinete-compartilhado mk --external_table_definition=dou_bruto.json views_publicos.dou_bruto

# Hard-coded to build the EXTERNAL TABLE 'servidores_federais_militares_cadastro' in dataset 'testing_mess'
schema=`head -n1 ~/gabinete/projetos/fiscalizacao/dados/servidores-executivo-federal/limpos/militares/201301_CadastroMilitares_cleaned.csv | sed -e 's/,/:STRING,/g' -e '1s/^\xEF\xBB\xBF//' | awk '{print $1":STRING"}'`
bq --project_id=gabinete-compartilhado mkdef --noautodetect --source_format=CSV --hive_partitioning_mode=CUSTOM --hive_partitioning_source_uri_prefix=gs://brutos-publicos/teste/{data:DATE} gs://brutos-publicos/teste/*_CadastroMilitares_cleaned.csv ${schema} | sed 's/"skipLeadingRows": 0/"skipLeadingRows": 1/g' > table_definition_files/servidores_federais_militares_cadastro.json
bq --project_id=gabinete-compartilhado mk --external_table_definition=table_definition_files/servidores_federais_militares_cadastro.json testing_mess.servidores_federais_militares_cadastro

# Hard-coded to build the EXTERNAL TABLE 'servidores_federais_militares_remuneracao' in dataset 'testing_mess'
schema=`head -n1 ~/gabinete/projetos/fiscalizacao/dados/servidores-executivo-federal/limpos/militares/201301_RemuneracaoMilitares_cleaned.csv | sed -e 's/,/:STRING,/g' -e '1s/^\xEF\xBB\xBF//' | awk '{print $1":STRING"}'`
bq --project_id=gabinete-compartilhado mkdef --noautodetect --source_format=CSV --hive_partitioning_mode=CUSTOM --hive_partitioning_source_uri_prefix=gs://brutos-publicos/teste/{data:DATE} gs://brutos-publicos/teste/*_RemuneracaoMilitares_cleaned.csv ${schema} | sed 's/"skipLeadingRows": 0/"skipLeadingRows": 1/g' > table_definition_files/servidores_federais_militares_remuneracao.json
bq --project_id=gabinete-compartilhado mk --external_table_definition=table_definition_files/servidores_federais_militares_remuneracao.json testing_mess.servidores_federais_militares_remuneracao

# Hard-coded to build the EXTERNAL TABLE 'servidores_federais_militares_jetons' in dataset 'testing_mess'
schema=`head -n1 ~/gabinete/projetos/fiscalizacao/dados/servidores-executivo-federal/limpos/militares/201301_Honorarios\(Jetons\)Militares_cleaned.csv | sed -e 's/,/:STRING,/g' -e '1s/^\xEF\xBB\xBF//' | awk '{print $1":STRING"}'`
bq --project_id=gabinete-compartilhado mkdef --noautodetect --source_format=CSV --hive_partitioning_mode=CUSTOM --hive_partitioning_source_uri_prefix=gs://brutos-publicos/teste/{data:DATE} gs://brutos-publicos/teste/*_Honorarios\(Jetons\)Militares_cleaned.csv ${schema} | sed 's/"skipLeadingRows": 0/"skipLeadingRows": 1/g' > table_definition_files/servidores_federais_militares_jetons.json
bq --project_id=gabinete-compartilhado mk --external_table_definition=table_definition_files/servidores_federais_militares_jetons.json testing_mess.servidores_federais_militares_jetons

# Hard-coded to build the EXTERNAL TABLE 'servidores_federais_militares_observacoes' in dataset 'testing_mess'
schema=`head -n1 ~/gabinete/projetos/fiscalizacao/dados/servidores-executivo-federal/limpos/militares/201301_ObservacoesMilitares_cleaned.csv | sed -e 's/,/:STRING,/g' -e '1s/^\xEF\xBB\xBF//' | awk '{print $1":STRING"}'`
bq --project_id=gabinete-compartilhado mkdef --noautodetect --source_format=CSV --hive_partitioning_mode=CUSTOM --hive_partitioning_source_uri_prefix=gs://brutos-publicos/teste/{data:DATE} gs://brutos-publicos/teste/*_ObservacoesMilitares_cleaned.csv ${schema} | sed 's/"skipLeadingRows": 0/"skipLeadingRows": 1/g' > table_definition_files/servidores_federais_militares_observacoes.json
bq --project_id=gabinete-compartilhado mk --external_table_definition=table_definition_files/servidores_federais_militares_observacoes.json testing_mess.servidores_federais_militares_observacoes

# Hard-coded to build the EXTERNAL TABLE 'cadastro_militares' in dataset 'executivo_federal_servidores'
schema=`head -n1 ~/gabinete/projetos/fiscalizacao/dados/servidores-executivo-federal/limpos/militares/201301_CadastroMilitares_cleaned.csv | sed -e 's/,/:STRING,/g' -e '1s/^\xEF\xBB\xBF//' | awk '{print $1":STRING"}'`
bq --project_id=gabinete-compartilhado mkdef --noautodetect --source_format=CSV --hive_partitioning_mode=CUSTOM --hive_partitioning_source_uri_prefix=gs://brutos-publicos/executivo/federal/servidores/partitioned/{data:DATE} gs://brutos-publicos/executivo/federal/servidores/partitioned/*_CadastroMilitares_cleaned.csv ${schema} | sed 's/"skipLeadingRows": 0/"skipLeadingRows": 1/g' > table_definition_files/servidores_federais_militares_cadastro.json
bq --project_id=gabinete-compartilhado mk --external_table_definition=table_definition_files/servidores_federais_militares_cadastro.json executivo_federal_servidores.cadastro_militares

# Hard-coded to build the EXTERNAL TABLE 'servidores_federais_militares_cadastro' in dataset 'views_publicos'
#schema=`head -n1 ~/gabinete/projetos/fiscalizacao/dados/servidores-executivo-federal/limpos/militares/201301_CadastroMilitares_cleaned.csv | sed -e 's/,/:STRING,/g' -e '1s/^\xEF\xBB\xBF//' | awk '{print $1":STRING"}'`
#bq --project_id=gabinete-compartilhado mkdef --noautodetect --source_format=CSV --hive_partitioning_mode=CUSTOM --hive_partitioning_source_uri_prefix=gs://brutos-publicos/executivo/federal/servidores/partitioned/{data:DATE} gs://brutos-publicos/executivo/federal/servidores/partitioned/*_CadastroMilitares_cleaned.csv ${schema} | sed 's/"skipLeadingRows": 0/"skipLeadingRows": 1/g' > table_definition_files/servidores_federais_militares_cadastro.json
bq --project_id=gabinete-compartilhado mk --external_table_definition=table_definition_files/servidores_federais_militares_cadastro.json views_publicos.servidores_federais_militares_cadastro

# Hard-coded to build the EXTERNAL TABLE 'servidores_executivo_federal_civis_cadastro' in dataset 'views_publicos'
schema=`head -n1 ~/gabinete/projetos/fiscalizacao/dados/servidores-executivo-federal/limpos/civis/202009_Cadastro_cleaned.csv | sed -e 's/,/:STRING,/g' -e '1s/^\xEF\xBB\xBF//' | awk '{print $1":STRING"}'`
bq --project_id=gabinete-compartilhado mkdef --noautodetect --source_format=CSV --hive_partitioning_mode=CUSTOM --hive_partitioning_source_uri_prefix=gs://brutos-publicos/executivo/federal/servidores/partitioned/{data:DATE} gs://brutos-publicos/executivo/federal/servidores/partitioned/*_Cadastro_cleaned.csv ${schema} | sed 's/"skipLeadingRows": 0/"skipLeadingRows": 1/g' > table_definition_files/servidores_federais_civis_cadastro.json
bq --project_id=gabinete-compartilhado mk --external_table_definition=table_definition_files/servidores_federais_civis_cadastro.json views_publicos.servidores_executivo_federal_civis_cadastro

# Hard-coded to build the EXTERNAL TABLE 'cadastro_civis' in dataset 'executivo_federal_servidores'
bq --project_id=gabinete-compartilhado mk --external_table_definition=table_definition_files/servidores_federais_civis_cadastro.json executivo_federal_servidores.cadastro_civis

# Hard-coded to build the EXTERNAL TABLE 'consulta_cand' in dataset 'tratado_tse'
schema=`head -n1 ~/gabinete/projetos/laranjometro/dados/limpos/consulta_cand/consulta_cand_2020_BRASIL.csv | sed -e 's/,/:STRING,/g' -e 's/"//g' | awk '{print $1":STRING"}'`
bq --project_id=gabinete-compartilhado mkdef --noautodetect --source_format=CSV --hive_partitioning_mode=CUSTOM --hive_partitioning_source_uri_prefix=gs://brutos-publicos/judiciario/tse/candidatos/{part_ano:INTEGER}/{part_uf:STRING} gs://brutos-publicos/judiciario/tse/candidatos/*.csv ${schema} | sed 's/"skipLeadingRows": 0/"skipLeadingRows": 1/g' > table_definition_files/consulta_cand.json
bq --project_id=gabinete-compartilhado mk --external_table_definition=table_definition_files/consulta_cand.json tratado_tse.consulta_candidatos

# Hard-coded to build the EXTERNAL TABLE 'consulta_cand' in dataset 'tratado_tse'
schema=`head -n1 /home/skems/gabinete/dados/tse/limpos/prestacao_de_contas_eleitorais_candidatos/2014/receitas_candidatos_2014_BRASIL.csv | sed -e 's/,/:STRING,/g' | awk '{print $1":STRING"}'`
bq --project_id=gabinete-compartilhado mkdef --noautodetect --source_format=CSV  gs://brutos-publicos/judiciario/tse/prestacao_contas/candidatos/part_ano=2014/receitas_candidatos_2014_*.csv ${schema} | sed 's/"skipLeadingRows": 0/"skipLeadingRows": 1/g' > table_definition_files/receitas_candidatos_2014.json
bq --project_id=gabinete-compartilhado mk --external_table_definition=table_definition_files/receitas_candidatos_2014.json tratado_tse.receitas_candidatos_2014

# Cria tabela externa de classificações de matérias do senado a partir de ementas, usando machine learning:
schema=`head -n1 /home/skems/gabinete/projetos/perfil_parlamentares/resultados/classificacao_automatica_materias_senado_2021-04-21.csv | sed -e 's/"//g' -e 's/,/:STRING,/g' | awk '{print $1":STRING"}' | sed -e 's/Codigo_Materia:STRING/Codigo_Materia:INTEGER/g'`
bq --project_id=gabinete-compartilhado mkdef --noautodetect --source_format=CSV  gs://brutos-publicos/legislativo/senado/gabinete/proposicoes/classificacao_automatica_materias_senado_2021-04-21.csv ${schema} | sed 's/"skipLeadingRows": 0/"skipLeadingRows": 1/g' > table_definition_files/classificacao_auto_materias_senado.json
bq --project_id=gabinete-compartilhado mk --external_table_definition=table_definition_files/classificacao_auto_materias_senado.json bruto_gabinete_administrativo.senado_proposicoes_temas_auto

# Cria tabela de tweets das listas:
bq --project_id=gabinete-compartilhado mk --external_table_definition=table_definition_files/twitter_lists.json redes_sociais.tweets_listas

# Cria tabela de comissionados da câmara:
bq --project_id=gabinete-compartilhado mk --external_table_definition=table_definition_files/camara_deputados_comissionados.json camara_v1.deputados_comissionados

# Hard-coded to build the EXTERNAL TABLE  'v2_cadastro_siape' in dataset 'executivo_federal_servidores'
schema=`head -n1 ~/gabinete/projetos/fiscalizacao/dados/servidores-executivo-federal/limpos/v2/202106_Servidores_SIAPE/202106_Cadastro_cleaned.csv | sed -e 's/,/:STRING,/g' -e '1s/^\xEF\xBB\xBF//' | awk '{print $1":STRING"}'`
bq --project_id=gabinete-compartilhado mkdef --noautodetect --source_format=CSV --hive_partitioning_mode=CUSTOM --hive_partitioning_source_uri_prefix=gs://brutos-publicos/executivo/federal/servidores/partitioned_v2/SIAPE/{data:DATE} gs://brutos-publicos/executivo/federal/servidores/partitioned_v2/SIAPE/*_Cadastro_cleaned.csv ${schema} | sed 's/"skipLeadingRows": 0/"skipLeadingRows": 1/g' > table_definition_files/servidores_federais_v2_siape_cadastro.json
bq --project_id=gabinete-compartilhado mk --external_table_definition=table_definition_files/servidores_federais_v2_siape_cadastro.json executivo_federal_servidores.v2_cadastro_siape

# Hard-coded to build the EXTERNAL TABLE  'v2_cadastro_bacen' in dataset 'executivo_federal_servidores'
schema=`head -n1 ~/gabinete/projetos/fiscalizacao/dados/servidores-executivo-federal/limpos/v2/202106_Servidores_BACEN/202106_Cadastro_cleaned.csv | sed -e 's/,/:STRING,/g' -e '1s/^\xEF\xBB\xBF//' | awk '{print $1":STRING"}'`
bq --project_id=gabinete-compartilhado mkdef --noautodetect --source_format=CSV --hive_partitioning_mode=CUSTOM --hive_partitioning_source_uri_prefix=gs://brutos-publicos/executivo/federal/servidores/partitioned_v2/BACEN/{data:DATE} gs://brutos-publicos/executivo/federal/servidores/partitioned_v2/BACEN/*_Cadastro_cleaned.csv ${schema} | sed 's/"skipLeadingRows": 0/"skipLeadingRows": 1/g' > table_definition_files/servidores_federais_v2_bacen_cadastro.json
bq --project_id=gabinete-compartilhado mk --external_table_definition=table_definition_files/servidores_federais_v2_bacen_cadastro.json executivo_federal_servidores.v2_cadastro_bacen

# Hard-coded to build the EXTERNAL TABLE  'v2_cadastro_militares' in dataset 'executivo_federal_servidores'
schema=`head -n1 ~/gabinete/projetos/fiscalizacao/dados/servidores-executivo-federal/limpos/v2/202106_Militares/202106_Cadastro_cleaned.csv | sed -e 's/,/:STRING,/g' -e '1s/^\xEF\xBB\xBF//' | awk '{print $1":STRING"}'`
bq --project_id=gabinete-compartilhado mkdef --noautodetect --source_format=CSV --hive_partitioning_mode=CUSTOM --hive_partitioning_source_uri_prefix=gs://brutos-publicos/executivo/federal/servidores/partitioned_v2/Militares/{data:DATE} gs://brutos-publicos/executivo/federal/servidores/partitioned_v2/Militares/*_Cadastro_cleaned.csv ${schema} | sed 's/"skipLeadingRows": 0/"skipLeadingRows": 1/g' > table_definition_files/servidores_federais_v2_militares_cadastro.json
bq --project_id=gabinete-compartilhado mk --external_table_definition=table_definition_files/servidores_federais_v2_militares_cadastro.json executivo_federal_servidores.v2_cadastro_militares

