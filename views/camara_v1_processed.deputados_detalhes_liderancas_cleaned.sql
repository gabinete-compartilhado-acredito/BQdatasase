/***
    Tabela com seleção de detalhes dos deputados segundo a versão 1 da API.
    Ela inclui todos os detalhes fora de arrays mais as do array de:
    HISTÓRICO DE LIDERANÇAS (unnested).
    Note que cada informação unnested do array em cada legislatura de cada deputado 
    aparece em uma linha separada, isto é: o mesmo deputado e a mesma legislatura aparecem 
    múltiplas vezes na tabela.
    
    PS: deputados podem trocar de nome (e provavelmente outros dados) de uma legislatura 
    para a outra, mas o id permanece o mesmo.
          
    PS2: Se um deputado não tem info no unnested array em questão, ele nem aparece nessa tabela.
    
    PS3: Durante um período em que um deputado é vice-lider, ele pode se tornar líder sem que 
    o registro de vice-líder perca a validade.
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
  lider.idHistoricoLider AS id_deputado_lider,
  lider.numOrdemCargo AS ordem_cargo_lideranca,
  PARSE_DATE('%d/%m/%Y', lider.dataDesignacao) AS data_designacao,
  PARSE_DATE('%d/%m/%Y', lider.dataTermino) AS data_termino,
  lider.idCargoLideranca AS id_cargo_lideranca,
  lider.descricaoCargoLideranca AS descricao_cargo_lideranca,
  lider.codigoUnidadeLideranca AS cod_tipo_lideranca,
  lider.idBlocoPartido AS id_bloco_partido,
  lider.siglaUnidadeLideranca AS sigla_lideranca_original,
  
  -- Info da captura:
  PARSE_DATETIME('%Y-%m-%d %H:%M:%S', capture_date) AS capture_date,
  api_url
  
FROM `gabinete-compartilhado.camara_v1.deputados_detalhes` AS d,
UNNEST(d.historicoLider.itemHistoricoLider) AS lider
ORDER BY id_deputado, legislatura DESC
