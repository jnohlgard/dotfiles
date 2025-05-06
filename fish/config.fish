if status is-interactive
    # Commands to run in interactive sessions can go here
    function dtsb
      dtc -I dts -O dtb $argv
    end
    function dtbs
      dtc -I dtb -O dts $argv
    end
end
