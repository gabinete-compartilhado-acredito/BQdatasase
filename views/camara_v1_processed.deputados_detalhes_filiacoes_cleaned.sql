/***
    Tabela com seleção de detalhes dos deputados segundo a versão 1 da API.
    Ela inclui todos os detalhes fora de arrays mais as do array de:
    FILIAÇÕES PARTIDÁRIAS (unnested).
    Note que cada informação unnested do array em cada legislatura de cada deputado 
    aparece em uma linha separada, isto é: o mesmo deputado e a mesma legislatura aparecem 
    múltiplas vezes na tabela.
    
    PS: deputados podem trocar de nome (e provavelmente outros dados) de uma legislatura 
    para a outra, mas o id permanece o mesmo.
          
    PS2: Se um deputado não tem info no unnested array em questão, ele nem aparece nessa tabela.
 ***/

SELECT 
  -- Id do deputado:
  ideCadastro AS id_deputado,
  idParlamentarDeprecated AS id_deprecated,
  nomeParlamentarAtual AS nome_atual,
  nomeCivil AS nome_civil,
  -- Infos do deputado:
  sexo,
  nomeProfissao AS profissao,
  PARSE_DATE('%d/%m/%Y', dataNascimento) AS data_nascimento,
  PARSE_DATE('%d/%m/%Y', dataFalecimento) AS data_falecimento,
  -- Legislatura:
  numLegislatura AS legislatura,
  situacaoNaLegislaturaAtual AS situacao_atual,
  -- Info do partido:
  partidoAtual.idPartido AS id_partido,
  partidoAtual.nome AS nome_partido,
  partidoAtual.sigla AS sigla_partido_original,
  -- Info do estado:
  ufRepresentacaoAtual AS uf_atual,
  -- Contatos:
  gabinete.anexo AS gabinete_anexo,
  gabinete.numero AS gabinete_numero,
  gabinete.telefone AS gabinete_telefone,
  email,
  
  -- Info da troca de partido:
  PARSE_DATE('%d/%m/%Y', filiacoes.dataFiliacaoPartidoPosterior) AS data_troca_partido,
  filiacoes.horaFiliacaoPartidoPosterior AS hora_troca_partido,
  -- Partido anterior:
  filiacoes.idPartidoAnterior AS id_partido_anterior, 
  filiacoes.siglaPartidoAnterior AS sigla_partido_anterior_original, 
  filiacoes.nomePartidoAnterior AS nome_partido_anterior,
  -- Partido posterior:
  filiacoes.idPartidoPosterior AS id_partido_posterior, 
  filiacoes.siglaPartidoPosterior AS sigla_partido_posterior_original, 
  filiacoes.nomePartidoPosterior AS nome_partido_posterior,
  
  -- Info da captura:
  PARSE_DATETIME('%Y-%m-%d %H:%M:%S', capture_date) AS capture_date,
  api_url
  
FROM `gabinete-compartilhado.camara_v1.deputados_detalhes` AS d,
UNNEST(d.filiacoesPartidarias.filiacaoPartidaria) AS filiacoes
ORDER BY id_deputado, legislatura DESC
