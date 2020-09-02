# TListBoxItemCustom
unit FMX personalizada para itens de listBox

para utilizar a classe, é necessário adicionar a referencia uCustomListBoxItem no uses de sua Form.

Adicionar componente ListBox em sua form sem nenhum item.
Adicionar componentes de imagem que serão utilizados como icone em botões;

criar classe no evento FormCreate passando como parametro o componente ListBox que foi criado em seu form, e 2 bitmaps dos componentes de imagens Ex:
 -> customListBoxItem := TCustomListBoxItem.Create(ListBox, Image1.Bitmap, Image2.Bitmap);
 
 Para adicionar um item ao seu ListBox é so chamar a classe customListBoxItem que foi criada no evento FormCreate e chamar o método AdicionarItem(),
 onde deve ser passado 2 parametros, o primeiro será o identificador, deve ser único, o segundo é a descrição que será apresentada na tela Ex:  
 -> customListBoxItem.AdicionarItem('1', 'Sou o primeiro item do ListBox'); 
  
  Caso queira remover algum item da ListBox é so Chamar o método removerItem(), e passar o item que deseja ser removido Ex:   
  -> customListBoxItem.removerItem(1); 
  
  Caso queira remover todos os itens, deve ser chamado o método removerTodos(), ao ser executado, todo os itens serão removidos da sua ListBox Ex: 
  -> customListBoxItem.removerTodos();
 
 Caso precise capturar a quantidade informada no item, basta chamar o evento retornarQuantidadeItem(), e passar o item que deseja capturar a quantidade Ex:
 -> nValor := customListBoxItem.retornarQuantidadeItem(1);
 
 
