function timire
    switch (date +"%u")
        case 1
        set times 09:40 10:50 10:55 11:25 12:35 12:50 14:05
        case 2
        set times 08:00 09:10 10:45 11:20 12:50 13:10 14:25
        case 3
        set times 09:35 10:55 11:05 12:30 12:35 13:05 14:30 14:50 16:20
        case 4
        set times 08:00 09:10 10:45 12:05 12:10 13:00 14:30 14:50 16:20
        case 5
        set times 08:00 09:10 09:10 09:25 09:25 10:40 11:05 12:35 12:50 13:30 14:50 14:55 16:20
    end
    for i in $times
        termdown $i
    end
end
