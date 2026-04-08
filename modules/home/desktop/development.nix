# Development editors: Zed configuration
{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      "toml"
      "dockerfile"
      "make"
      "html"
    ];
    extraPackages = [ pkgs.nixd ];

    userSettings = {
      theme = "One Dark";
      ui_font_size = 16;
      buffer_font_size = 14;
      title_bar.show_menus = true;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      vim_mode = false;
      format_on_save = "on";
      auto_install_extensions = {
        csv = true;
        dockerfile = true;
        docker-compose = true;
        html = true;
        nix = true;
        ruff = true;
        toml = true;
        terraform = true;
      };
      agent_servers = {
        "OpenCode" = {
          type = "custom";
          command = "opencode";
          args = [ "acp" ];
        };
      };
      ssh_connections = [
        {
          host = "dev.adm.ptre.es";
          username = "louis";
          port = 22;
        }
      ];
      agent = {
        default_model = {
          provider = "Z.AI";
          model = "glm-5.1";
          enable_thinking = false;
        };
        favorite_models = [ ];
        model_parameters = [ ];
      };
      language_models = {
        openai_compatible = {
          "Z.AI" = {
            api_url = "https://api.z.ai/api/coding/paas/v4";
            available_models = [
              {
                name = "glm-5.1";
                max_tokens = 200000;
                max_output_tokens = 32000;
                max_completion_tokens = 200000;
                capabilities = {
                  tools = true;
                  images = false;
                  parallel_tool_calls = false;
                  prompt_cache_key = false;
                  chat_completions = true;
                };
              }
            ];
          };
        };
      };
    };
  };
}
