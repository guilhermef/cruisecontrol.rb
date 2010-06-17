jQuery(".show-all").each(
    function (){ 
        jQuery(this).live('click',
            function(){
					
                    jQuery(this+".builds_list .last_4").animate({
                        opacity: 'toggle',
                        height: 'toggle'
                        }, 
                        {
                        duration: 1000,
                        specialEasing: {
                        height: 'linear'
                        }
                    });
            }
        );
    }
);