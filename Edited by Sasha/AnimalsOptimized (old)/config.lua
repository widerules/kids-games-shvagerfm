if ( display.pixelHeight / display.pixelWidth > 1.7) then
   application =
   {
      content =
      {
         width = 720,
         height = 1280,
         scale = "letterBox",
         xAlign = "center",
         yAlign = "center",

      },
   }
 
elseif (display.pixelHeight / display.pixelWidth > 1.6) then
   application =
   {
      content =
      {
         width = 480,
         height = 800,
         scale = "letterBox",
         xAlign = "center",
         yAlign = "center",

      },
   }
  elseif (display.pixelHeight / display.pixelWidth < 1.4) then
   application =
   {
      content =
      {
         width = 1024,
         height = 768,
         scale = "letterBox",
         xAlign = "center",
         yAlign = "center",

      },
   }
    
end

    --[[
    -- Push notifications

    notification =
    {
        iphone =
        {
            types =
            {
                "badge", "sound", "alert", "newsstand"
            }
        }
    }
    --]]    

