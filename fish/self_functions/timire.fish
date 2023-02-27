function timire
    switch (date +"%u")
        case 1
        set times 08:00 09:40 09:50 10:55 11:10 11:40 12:45 13:00 14:00
        case 2
        set times 08:00 09:20 09:40 10:45 10:55 12:35 12:40 13:15 14:30 15:00 16:20
        case 3
        set times 08:25 09:55 10:00 10:30 10:55 12:20 12:25 13:00 14:30 14:55 16:10
        case 4
        set times 09:05 10:35 11:10 11:45 12:55 13:40 15:20
        case 5
        set times 08:00 09:20 09:35 11:00 11:10 12:15 12:25 12:55 14:10
    end
    for i in $times
        termdown $i
    end
end










