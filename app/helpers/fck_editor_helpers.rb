module FckEditorHelpers
  def fckeditor_textarea(object, method, value)
    <<-HTML
      <script type="text/javascript">
        <!--
        oFCKeditor = new FCKeditor('#{object}[#{method}]');
        oFCKeditor.Config['ToolbarStartExpanded'] = true;
        oFCKeditor.ToolbarSet = 'Basic';
        oFCKeditor.Value = '#{escape_javascript(value)}';
        oFCKeditor.Create();
        //-->
      </script>
    HTML
  end
end
