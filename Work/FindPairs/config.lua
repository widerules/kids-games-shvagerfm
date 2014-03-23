if ( display.pixelHeight / display.pixelWidth > 1.77 ) then
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
 
else
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
 
end