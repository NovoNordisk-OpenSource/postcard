# `repeat_power_marginaleffect` and plot snapshot tests

    Code
      rpm
    Output
      # A tibble: 10 x 11
          power     n model  flag_achieve_power desired_power samplesize target_effect
       *  <dbl> <dbl> <chr>  <lgl>                      <dbl>      <int>         <dbl>
       1 0.0791   100 ANCOVA FALSE                        0.9         10           0.9
       2 0.0782   100 ANCOV~ FALSE                        0.9         10           0.9
       3 0.121    200 ANCOVA FALSE                        0.9         10           0.9
       4 0.123    200 ANCOV~ FALSE                        0.9         10           0.9
       5 0.171    300 ANCOVA FALSE                        0.9         10           0.9
       6 0.158    300 ANCOV~ FALSE                        0.9         10           0.9
       7 0.210    400 ANCOVA FALSE                        0.9         10           0.9
       8 0.223    400 ANCOV~ FALSE                        0.9         10           0.9
       9 0.238    500 ANCOVA FALSE                        0.9         10           0.9
      10 0.251    500 ANCOV~ FALSE                        0.9         10           0.9
      # i 4 more variables: exposure_prob <dbl>, margin <dbl>, alpha <dbl>,
      #   power_fun <chr>

---

    Code
      rpm_cars
    Output
      # A tibble: 12 x 11
          power     n model  flag_achieve_power desired_power samplesize target_effect
       *  <dbl> <dbl> <chr>  <lgl>                      <dbl>      <int>         <dbl>
       1 0.0662     5 ANCOVA FALSE                        0.9         12           0.9
       2 0.0763     5 NullM~ FALSE                        0.9         12           0.9
       3 0.0781    10 ANCOVA FALSE                        0.9         12           0.9
       4 0.0609    10 NullM~ FALSE                        0.9         12           0.9
       5 0.0825    15 ANCOVA FALSE                        0.9         12           0.9
       6 0.0564    15 NullM~ FALSE                        0.9         12           0.9
       7 0.0577    20 ANCOVA FALSE                        0.9         12           0.9
       8 0.0444    20 NullM~ FALSE                        0.9         12           0.9
       9 0.0655    25 ANCOVA FALSE                        0.9         12           0.9
      10 0.0492    25 NullM~ FALSE                        0.9         12           0.9
      11 0.0714    30 ANCOVA FALSE                        0.9         12           0.9
      12 0.0516    30 NullM~ FALSE                        0.9         12           0.9
      # i 4 more variables: exposure_prob <dbl>, margin <dbl>, alpha <dbl>,
      #   power_fun <chr>

# `repeat_power_linear` and plot snapshot tests

    Code
      rpl
    Output
            n               model      power flag_achieve_power desired_power
      1    10  ANCOVA 1 covariate 0.07635145              FALSE           0.9
      2    11  ANCOVA 1 covariate 0.08102487              FALSE           0.9
      3    12  ANCOVA 1 covariate 0.08564308              FALSE           0.9
      4    13  ANCOVA 1 covariate 0.09021769              FALSE           0.9
      5    14  ANCOVA 1 covariate 0.09475742              FALSE           0.9
      6    15  ANCOVA 1 covariate 0.09926895              FALSE           0.9
      7    16  ANCOVA 1 covariate 0.10375750              FALSE           0.9
      8    17  ANCOVA 1 covariate 0.10822717              FALSE           0.9
      9    18  ANCOVA 1 covariate 0.11268122              FALSE           0.9
      10   19  ANCOVA 1 covariate 0.11712229              FALSE           0.9
      11   20  ANCOVA 1 covariate 0.12155247              FALSE           0.9
      12   21  ANCOVA 1 covariate 0.12597348              FALSE           0.9
      13   22  ANCOVA 1 covariate 0.13038671              FALSE           0.9
      14   23  ANCOVA 1 covariate 0.13479327              FALSE           0.9
      15   24  ANCOVA 1 covariate 0.13919407              FALSE           0.9
      16   25  ANCOVA 1 covariate 0.14358983              FALSE           0.9
      17   26  ANCOVA 1 covariate 0.14798113              FALSE           0.9
      18   27  ANCOVA 1 covariate 0.15236842              FALSE           0.9
      19   28  ANCOVA 1 covariate 0.15675206              FALSE           0.9
      20   29  ANCOVA 1 covariate 0.16113229              FALSE           0.9
      21   30  ANCOVA 1 covariate 0.16550930              FALSE           0.9
      22   31  ANCOVA 1 covariate 0.16988322              FALSE           0.9
      23   32  ANCOVA 1 covariate 0.17425411              FALSE           0.9
      24   33  ANCOVA 1 covariate 0.17862198              FALSE           0.9
      25   34  ANCOVA 1 covariate 0.18298682              FALSE           0.9
      26   35  ANCOVA 1 covariate 0.18734856              FALSE           0.9
      27   36  ANCOVA 1 covariate 0.19170714              FALSE           0.9
      28   37  ANCOVA 1 covariate 0.19606242              FALSE           0.9
      29   38  ANCOVA 1 covariate 0.20041429              FALSE           0.9
      30   39  ANCOVA 1 covariate 0.20476259              FALSE           0.9
      31   40  ANCOVA 1 covariate 0.20910715              FALSE           0.9
      32   41  ANCOVA 1 covariate 0.21344779              FALSE           0.9
      33   42  ANCOVA 1 covariate 0.21778432              FALSE           0.9
      34   43  ANCOVA 1 covariate 0.22211654              FALSE           0.9
      35   44  ANCOVA 1 covariate 0.22644424              FALSE           0.9
      36   45  ANCOVA 1 covariate 0.23076719              FALSE           0.9
      37   46  ANCOVA 1 covariate 0.23508518              FALSE           0.9
      38   47  ANCOVA 1 covariate 0.23939798              FALSE           0.9
      39   48  ANCOVA 1 covariate 0.24370535              FALSE           0.9
      40   49  ANCOVA 1 covariate 0.24800706              FALSE           0.9
      41   50  ANCOVA 1 covariate 0.25230287              FALSE           0.9
      42   51  ANCOVA 1 covariate 0.25659255              FALSE           0.9
      43   52  ANCOVA 1 covariate 0.26087585              FALSE           0.9
      44   53  ANCOVA 1 covariate 0.26515254              FALSE           0.9
      45   54  ANCOVA 1 covariate 0.26942238              FALSE           0.9
      46   55  ANCOVA 1 covariate 0.27368512              FALSE           0.9
      47   56  ANCOVA 1 covariate 0.27794053              FALSE           0.9
      48   57  ANCOVA 1 covariate 0.28218838              FALSE           0.9
      49   58  ANCOVA 1 covariate 0.28642842              FALSE           0.9
      50   59  ANCOVA 1 covariate 0.29066042              FALSE           0.9
      51   60  ANCOVA 1 covariate 0.29488415              FALSE           0.9
      52   61  ANCOVA 1 covariate 0.29909939              FALSE           0.9
      53   62  ANCOVA 1 covariate 0.30330590              FALSE           0.9
      54   63  ANCOVA 1 covariate 0.30750346              FALSE           0.9
      55   64  ANCOVA 1 covariate 0.31169185              FALSE           0.9
      56   65  ANCOVA 1 covariate 0.31587085              FALSE           0.9
      57   66  ANCOVA 1 covariate 0.32004025              FALSE           0.9
      58   67  ANCOVA 1 covariate 0.32419982              FALSE           0.9
      59   68  ANCOVA 1 covariate 0.32834937              FALSE           0.9
      60   69  ANCOVA 1 covariate 0.33248868              FALSE           0.9
      61   70  ANCOVA 1 covariate 0.33661755              FALSE           0.9
      62   71  ANCOVA 1 covariate 0.34073578              FALSE           0.9
      63   72  ANCOVA 1 covariate 0.34484317              FALSE           0.9
      64   73  ANCOVA 1 covariate 0.34893954              FALSE           0.9
      65   74  ANCOVA 1 covariate 0.35302469              FALSE           0.9
      66   75  ANCOVA 1 covariate 0.35709844              FALSE           0.9
      67   76  ANCOVA 1 covariate 0.36116059              FALSE           0.9
      68   77  ANCOVA 1 covariate 0.36521098              FALSE           0.9
      69   78  ANCOVA 1 covariate 0.36924943              FALSE           0.9
      70   79  ANCOVA 1 covariate 0.37327577              FALSE           0.9
      71   80  ANCOVA 1 covariate 0.37728982              FALSE           0.9
      72   81  ANCOVA 1 covariate 0.38129142              FALSE           0.9
      73   82  ANCOVA 1 covariate 0.38528041              FALSE           0.9
      74   83  ANCOVA 1 covariate 0.38925664              FALSE           0.9
      75   84  ANCOVA 1 covariate 0.39321994              FALSE           0.9
      76   85  ANCOVA 1 covariate 0.39717018              FALSE           0.9
      77   86  ANCOVA 1 covariate 0.40110719              FALSE           0.9
      78   87  ANCOVA 1 covariate 0.40503083              FALSE           0.9
      79   88  ANCOVA 1 covariate 0.40894097              FALSE           0.9
      80   89  ANCOVA 1 covariate 0.41283747              FALSE           0.9
      81   90  ANCOVA 1 covariate 0.41672020              FALSE           0.9
      82   91  ANCOVA 1 covariate 0.42058901              FALSE           0.9
      83   92  ANCOVA 1 covariate 0.42444380              FALSE           0.9
      84   93  ANCOVA 1 covariate 0.42828442              FALSE           0.9
      85   94  ANCOVA 1 covariate 0.43211078              FALSE           0.9
      86   95  ANCOVA 1 covariate 0.43592273              FALSE           0.9
      87   96  ANCOVA 1 covariate 0.43972018              FALSE           0.9
      88   97  ANCOVA 1 covariate 0.44350301              FALSE           0.9
      89   98  ANCOVA 1 covariate 0.44727112              FALSE           0.9
      90   99  ANCOVA 1 covariate 0.45102439              FALSE           0.9
      91  100  ANCOVA 1 covariate 0.45476274              FALSE           0.9
      92  101  ANCOVA 1 covariate 0.45848605              FALSE           0.9
      93  102  ANCOVA 1 covariate 0.46219424              FALSE           0.9
      94  103  ANCOVA 1 covariate 0.46588722              FALSE           0.9
      95  104  ANCOVA 1 covariate 0.46956489              FALSE           0.9
      96  105  ANCOVA 1 covariate 0.47322717              FALSE           0.9
      97  106  ANCOVA 1 covariate 0.47687398              FALSE           0.9
      98  107  ANCOVA 1 covariate 0.48050524              FALSE           0.9
      99  108  ANCOVA 1 covariate 0.48412086              FALSE           0.9
      100 109  ANCOVA 1 covariate 0.48772078              FALSE           0.9
      101 110  ANCOVA 1 covariate 0.49130493              FALSE           0.9
      102 111  ANCOVA 1 covariate 0.49487322              FALSE           0.9
      103 112  ANCOVA 1 covariate 0.49842561              FALSE           0.9
      104 113  ANCOVA 1 covariate 0.50196202              FALSE           0.9
      105 114  ANCOVA 1 covariate 0.50548240              FALSE           0.9
      106 115  ANCOVA 1 covariate 0.50898668              FALSE           0.9
      107 116  ANCOVA 1 covariate 0.51247481              FALSE           0.9
      108 117  ANCOVA 1 covariate 0.51594674              FALSE           0.9
      109 118  ANCOVA 1 covariate 0.51940242              FALSE           0.9
      110 119  ANCOVA 1 covariate 0.52284180              FALSE           0.9
      111 120  ANCOVA 1 covariate 0.52626483              FALSE           0.9
      112 121  ANCOVA 1 covariate 0.52967147              FALSE           0.9
      113 122  ANCOVA 1 covariate 0.53306168              FALSE           0.9
      114 123  ANCOVA 1 covariate 0.53643542              FALSE           0.9
      115 124  ANCOVA 1 covariate 0.53979265              FALSE           0.9
      116 125  ANCOVA 1 covariate 0.54313335              FALSE           0.9
      117 126  ANCOVA 1 covariate 0.54645748              FALSE           0.9
      118 127  ANCOVA 1 covariate 0.54976500              FALSE           0.9
      119 128  ANCOVA 1 covariate 0.55305590              FALSE           0.9
      120 129  ANCOVA 1 covariate 0.55633015              FALSE           0.9
      121 130  ANCOVA 1 covariate 0.55958772              FALSE           0.9
      122 131  ANCOVA 1 covariate 0.56282859              FALSE           0.9
      123 132  ANCOVA 1 covariate 0.56605275              FALSE           0.9
      124 133  ANCOVA 1 covariate 0.56926017              FALSE           0.9
      125 134  ANCOVA 1 covariate 0.57245085              FALSE           0.9
      126 135  ANCOVA 1 covariate 0.57562477              FALSE           0.9
      127 136  ANCOVA 1 covariate 0.57878191              FALSE           0.9
      128 137  ANCOVA 1 covariate 0.58192228              FALSE           0.9
      129 138  ANCOVA 1 covariate 0.58504586              FALSE           0.9
      130 139  ANCOVA 1 covariate 0.58815264              FALSE           0.9
      131 140  ANCOVA 1 covariate 0.59124263              FALSE           0.9
      132 141  ANCOVA 1 covariate 0.59431581              FALSE           0.9
      133 142  ANCOVA 1 covariate 0.59737220              FALSE           0.9
      134 143  ANCOVA 1 covariate 0.60041179              FALSE           0.9
      135 144  ANCOVA 1 covariate 0.60343458              FALSE           0.9
      136 145  ANCOVA 1 covariate 0.60644059              FALSE           0.9
      137 146  ANCOVA 1 covariate 0.60942981              FALSE           0.9
      138 147  ANCOVA 1 covariate 0.61240225              FALSE           0.9
      139 148  ANCOVA 1 covariate 0.61535793              FALSE           0.9
      140 149  ANCOVA 1 covariate 0.61829686              FALSE           0.9
      141 150  ANCOVA 1 covariate 0.62121904              FALSE           0.9
      142 151  ANCOVA 1 covariate 0.62412449              FALSE           0.9
      143 152  ANCOVA 1 covariate 0.62701323              FALSE           0.9
      144 153  ANCOVA 1 covariate 0.62988527              FALSE           0.9
      145 154  ANCOVA 1 covariate 0.63274064              FALSE           0.9
      146 155  ANCOVA 1 covariate 0.63557935              FALSE           0.9
      147 156  ANCOVA 1 covariate 0.63840142              FALSE           0.9
      148 157  ANCOVA 1 covariate 0.64120687              FALSE           0.9
      149 158  ANCOVA 1 covariate 0.64399573              FALSE           0.9
      150 159  ANCOVA 1 covariate 0.64676803              FALSE           0.9
      151 160  ANCOVA 1 covariate 0.64952379              FALSE           0.9
      152 161  ANCOVA 1 covariate 0.65226303              FALSE           0.9
      153 162  ANCOVA 1 covariate 0.65498579              FALSE           0.9
      154 163  ANCOVA 1 covariate 0.65769210              FALSE           0.9
      155 164  ANCOVA 1 covariate 0.66038198              FALSE           0.9
      156 165  ANCOVA 1 covariate 0.66305547              FALSE           0.9
      157 166  ANCOVA 1 covariate 0.66571260              FALSE           0.9
      158 167  ANCOVA 1 covariate 0.66835340              FALSE           0.9
      159 168  ANCOVA 1 covariate 0.67097792              FALSE           0.9
      160 169  ANCOVA 1 covariate 0.67358618              FALSE           0.9
      161 170  ANCOVA 1 covariate 0.67617823              FALSE           0.9
      162 171  ANCOVA 1 covariate 0.67875410              FALSE           0.9
      163 172  ANCOVA 1 covariate 0.68131383              FALSE           0.9
      164 173  ANCOVA 1 covariate 0.68385746              FALSE           0.9
      165 174  ANCOVA 1 covariate 0.68638504              FALSE           0.9
      166 175  ANCOVA 1 covariate 0.68889660              FALSE           0.9
      167 176  ANCOVA 1 covariate 0.69139218              FALSE           0.9
      168 177  ANCOVA 1 covariate 0.69387184              FALSE           0.9
      169 178  ANCOVA 1 covariate 0.69633561              FALSE           0.9
      170 179  ANCOVA 1 covariate 0.69878355              FALSE           0.9
      171 180  ANCOVA 1 covariate 0.70121569              FALSE           0.9
      172 181  ANCOVA 1 covariate 0.70363208              FALSE           0.9
      173 182  ANCOVA 1 covariate 0.70603278              FALSE           0.9
      174 183  ANCOVA 1 covariate 0.70841782              FALSE           0.9
      175 184  ANCOVA 1 covariate 0.71078727              FALSE           0.9
      176 185  ANCOVA 1 covariate 0.71314116              FALSE           0.9
      177 186  ANCOVA 1 covariate 0.71547955              FALSE           0.9
      178 187  ANCOVA 1 covariate 0.71780250              FALSE           0.9
      179 188  ANCOVA 1 covariate 0.72011004              FALSE           0.9
      180 189  ANCOVA 1 covariate 0.72240225              FALSE           0.9
      181 190  ANCOVA 1 covariate 0.72467916              FALSE           0.9
      182 191  ANCOVA 1 covariate 0.72694083              FALSE           0.9
      183 192  ANCOVA 1 covariate 0.72918732              FALSE           0.9
      184 193  ANCOVA 1 covariate 0.73141868              FALSE           0.9
      185 194  ANCOVA 1 covariate 0.73363496              FALSE           0.9
      186 195  ANCOVA 1 covariate 0.73583623              FALSE           0.9
      187 196  ANCOVA 1 covariate 0.73802254              FALSE           0.9
      188 197  ANCOVA 1 covariate 0.74019394              FALSE           0.9
      189 198  ANCOVA 1 covariate 0.74235050              FALSE           0.9
      190 199  ANCOVA 1 covariate 0.74449227              FALSE           0.9
      191 200  ANCOVA 1 covariate 0.74661931              FALSE           0.9
      192 201  ANCOVA 1 covariate 0.74873168              FALSE           0.9
      193 202  ANCOVA 1 covariate 0.75082944              FALSE           0.9
      194 203  ANCOVA 1 covariate 0.75291264              FALSE           0.9
      195 204  ANCOVA 1 covariate 0.75498135              FALSE           0.9
      196 205  ANCOVA 1 covariate 0.75703564              FALSE           0.9
      197 206  ANCOVA 1 covariate 0.75907555              FALSE           0.9
      198 207  ANCOVA 1 covariate 0.76110115              FALSE           0.9
      199 208  ANCOVA 1 covariate 0.76311250              FALSE           0.9
      200 209  ANCOVA 1 covariate 0.76510967              FALSE           0.9
      201 210  ANCOVA 1 covariate 0.76709271              FALSE           0.9
      202 211  ANCOVA 1 covariate 0.76906170              FALSE           0.9
      203 212  ANCOVA 1 covariate 0.77101669              FALSE           0.9
      204 213  ANCOVA 1 covariate 0.77295774              FALSE           0.9
      205 214  ANCOVA 1 covariate 0.77488492              FALSE           0.9
      206 215  ANCOVA 1 covariate 0.77679829              FALSE           0.9
      207 216  ANCOVA 1 covariate 0.77869792              FALSE           0.9
      208 217  ANCOVA 1 covariate 0.78058387              FALSE           0.9
      209 218  ANCOVA 1 covariate 0.78245620              FALSE           0.9
      210 219  ANCOVA 1 covariate 0.78431499              FALSE           0.9
      211 220  ANCOVA 1 covariate 0.78616028              FALSE           0.9
      212 221  ANCOVA 1 covariate 0.78799216              FALSE           0.9
      213 222  ANCOVA 1 covariate 0.78981068              FALSE           0.9
      214 223  ANCOVA 1 covariate 0.79161592              FALSE           0.9
      215 224  ANCOVA 1 covariate 0.79340792              FALSE           0.9
      216 225  ANCOVA 1 covariate 0.79518677              FALSE           0.9
      217 226  ANCOVA 1 covariate 0.79695253              FALSE           0.9
      218 227  ANCOVA 1 covariate 0.79870526              FALSE           0.9
      219 228  ANCOVA 1 covariate 0.80044503              FALSE           0.9
      220 229  ANCOVA 1 covariate 0.80217191              FALSE           0.9
      221 230  ANCOVA 1 covariate 0.80388595              FALSE           0.9
      222 231  ANCOVA 1 covariate 0.80558724              FALSE           0.9
      223 232  ANCOVA 1 covariate 0.80727583              FALSE           0.9
      224 233  ANCOVA 1 covariate 0.80895179              FALSE           0.9
      225 234  ANCOVA 1 covariate 0.81061519              FALSE           0.9
      226 235  ANCOVA 1 covariate 0.81226610              FALSE           0.9
      227 236  ANCOVA 1 covariate 0.81390458              FALSE           0.9
      228 237  ANCOVA 1 covariate 0.81553069              FALSE           0.9
      229 238  ANCOVA 1 covariate 0.81714452              FALSE           0.9
      230 239  ANCOVA 1 covariate 0.81874611              FALSE           0.9
      231 240  ANCOVA 1 covariate 0.82033554              FALSE           0.9
      232 241  ANCOVA 1 covariate 0.82191288              FALSE           0.9
      233 242  ANCOVA 1 covariate 0.82347820              FALSE           0.9
      234 243  ANCOVA 1 covariate 0.82503155              FALSE           0.9
      235 244  ANCOVA 1 covariate 0.82657301              FALSE           0.9
      236 245  ANCOVA 1 covariate 0.82810265              FALSE           0.9
      237 246  ANCOVA 1 covariate 0.82962053              FALSE           0.9
      238 247  ANCOVA 1 covariate 0.83112671              FALSE           0.9
      239 248  ANCOVA 1 covariate 0.83262127              FALSE           0.9
      240 249  ANCOVA 1 covariate 0.83410427              FALSE           0.9
      241 250  ANCOVA 1 covariate 0.83557578              FALSE           0.9
      242 251  ANCOVA 1 covariate 0.83703587              FALSE           0.9
      243 252  ANCOVA 1 covariate 0.83848459              FALSE           0.9
      244 253  ANCOVA 1 covariate 0.83992203              FALSE           0.9
      245 254  ANCOVA 1 covariate 0.84134824              FALSE           0.9
      246 255  ANCOVA 1 covariate 0.84276329              FALSE           0.9
      247 256  ANCOVA 1 covariate 0.84416725              FALSE           0.9
      248 257  ANCOVA 1 covariate 0.84556019              FALSE           0.9
      249 258  ANCOVA 1 covariate 0.84694216              FALSE           0.9
      250 259  ANCOVA 1 covariate 0.84831324              FALSE           0.9
      251 260  ANCOVA 1 covariate 0.84967349              FALSE           0.9
      252 261  ANCOVA 1 covariate 0.85102298              FALSE           0.9
      253 262  ANCOVA 1 covariate 0.85236178              FALSE           0.9
      254 263  ANCOVA 1 covariate 0.85368994              FALSE           0.9
      255 264  ANCOVA 1 covariate 0.85500754              FALSE           0.9
      256 265  ANCOVA 1 covariate 0.85631464              FALSE           0.9
      257 266  ANCOVA 1 covariate 0.85761130              FALSE           0.9
      258 267  ANCOVA 1 covariate 0.85889760              FALSE           0.9
      259 268  ANCOVA 1 covariate 0.86017359              FALSE           0.9
      260 269  ANCOVA 1 covariate 0.86143934              FALSE           0.9
      261 270  ANCOVA 1 covariate 0.86269492              FALSE           0.9
      262 271  ANCOVA 1 covariate 0.86394039              FALSE           0.9
      263 272  ANCOVA 1 covariate 0.86517581              FALSE           0.9
      264 273  ANCOVA 1 covariate 0.86640125              FALSE           0.9
      265 274  ANCOVA 1 covariate 0.86761677              FALSE           0.9
      266 275  ANCOVA 1 covariate 0.86882243              FALSE           0.9
      267 276  ANCOVA 1 covariate 0.87001831              FALSE           0.9
      268 277  ANCOVA 1 covariate 0.87120446              FALSE           0.9
      269 278  ANCOVA 1 covariate 0.87238094              FALSE           0.9
      270 279  ANCOVA 1 covariate 0.87354783              FALSE           0.9
      271 280  ANCOVA 1 covariate 0.87470518              FALSE           0.9
      272 281  ANCOVA 1 covariate 0.87585305              FALSE           0.9
      273 282  ANCOVA 1 covariate 0.87699151              FALSE           0.9
      274 283  ANCOVA 1 covariate 0.87812062              FALSE           0.9
      275 284  ANCOVA 1 covariate 0.87924044              FALSE           0.9
      276 285  ANCOVA 1 covariate 0.88035104              FALSE           0.9
      277 286  ANCOVA 1 covariate 0.88145247              FALSE           0.9
      278 287  ANCOVA 1 covariate 0.88254480              FALSE           0.9
      279 288  ANCOVA 1 covariate 0.88362809              FALSE           0.9
      280 289  ANCOVA 1 covariate 0.88470240              FALSE           0.9
      281 290  ANCOVA 1 covariate 0.88576779              FALSE           0.9
      282 291  ANCOVA 1 covariate 0.88682432              FALSE           0.9
      283 292  ANCOVA 1 covariate 0.88787205              FALSE           0.9
      284 293  ANCOVA 1 covariate 0.88891104              FALSE           0.9
      285 294  ANCOVA 1 covariate 0.88994136              FALSE           0.9
      286 295  ANCOVA 1 covariate 0.89096305              FALSE           0.9
      287 296  ANCOVA 1 covariate 0.89197619              FALSE           0.9
      288 297  ANCOVA 1 covariate 0.89298083              FALSE           0.9
      289 298  ANCOVA 1 covariate 0.89397703              FALSE           0.9
      290 299  ANCOVA 1 covariate 0.89496484              FALSE           0.9
      291 300  ANCOVA 1 covariate 0.89594434              FALSE           0.9
      292 301  ANCOVA 1 covariate 0.89691556              FALSE           0.9
      293 302  ANCOVA 1 covariate 0.89787858              FALSE           0.9
      294 303  ANCOVA 1 covariate 0.89883346              FALSE           0.9
      295 304  ANCOVA 1 covariate 0.89978024              FALSE           0.9
      296 305  ANCOVA 1 covariate 0.90071898               TRUE           0.9
      297 306  ANCOVA 1 covariate 0.90164975               TRUE           0.9
      298 307  ANCOVA 1 covariate 0.90257260               TRUE           0.9
      299 308  ANCOVA 1 covariate 0.90348759               TRUE           0.9
      300 309  ANCOVA 1 covariate 0.90439477               TRUE           0.9
      301 310  ANCOVA 1 covariate 0.90529420               TRUE           0.9
      302 311  ANCOVA 1 covariate 0.90618593               TRUE           0.9
      303 312  ANCOVA 1 covariate 0.90707003               TRUE           0.9
      304 313  ANCOVA 1 covariate 0.90794654               TRUE           0.9
      305 314  ANCOVA 1 covariate 0.90881552               TRUE           0.9
      306 315  ANCOVA 1 covariate 0.90967702               TRUE           0.9
      307 316  ANCOVA 1 covariate 0.91053111               TRUE           0.9
      308 317  ANCOVA 1 covariate 0.91137783               TRUE           0.9
      309 318  ANCOVA 1 covariate 0.91221724               TRUE           0.9
      310 319  ANCOVA 1 covariate 0.91304939               TRUE           0.9
      311 320  ANCOVA 1 covariate 0.91387434               TRUE           0.9
      312 321  ANCOVA 1 covariate 0.91469213               TRUE           0.9
      313 322  ANCOVA 1 covariate 0.91550283               TRUE           0.9
      314 323  ANCOVA 1 covariate 0.91630648               TRUE           0.9
      315 324  ANCOVA 1 covariate 0.91710314               TRUE           0.9
      316 325  ANCOVA 1 covariate 0.91789286               TRUE           0.9
      317 326  ANCOVA 1 covariate 0.91867569               TRUE           0.9
      318 327  ANCOVA 1 covariate 0.91945168               TRUE           0.9
      319 328  ANCOVA 1 covariate 0.92022089               TRUE           0.9
      320 329  ANCOVA 1 covariate 0.92098336               TRUE           0.9
      321 330  ANCOVA 1 covariate 0.92173915               TRUE           0.9
      322 331  ANCOVA 1 covariate 0.92248830               TRUE           0.9
      323 332  ANCOVA 1 covariate 0.92323087               TRUE           0.9
      324 333  ANCOVA 1 covariate 0.92396691               TRUE           0.9
      325 334  ANCOVA 1 covariate 0.92469646               TRUE           0.9
      326 335  ANCOVA 1 covariate 0.92541958               TRUE           0.9
      327 336  ANCOVA 1 covariate 0.92613632               TRUE           0.9
      328 337  ANCOVA 1 covariate 0.92684672               TRUE           0.9
      329 338  ANCOVA 1 covariate 0.92755083               TRUE           0.9
      330 339  ANCOVA 1 covariate 0.92824870               TRUE           0.9
      331 340  ANCOVA 1 covariate 0.92894038               TRUE           0.9
      332 341  ANCOVA 1 covariate 0.92962592               TRUE           0.9
      333 342  ANCOVA 1 covariate 0.93030537               TRUE           0.9
      334 343  ANCOVA 1 covariate 0.93097876               TRUE           0.9
      335 344  ANCOVA 1 covariate 0.93164615               TRUE           0.9
      336 345  ANCOVA 1 covariate 0.93230759               TRUE           0.9
      337 346  ANCOVA 1 covariate 0.93296313               TRUE           0.9
      338 347  ANCOVA 1 covariate 0.93361280               TRUE           0.9
      339 348  ANCOVA 1 covariate 0.93425665               TRUE           0.9
      340 349  ANCOVA 1 covariate 0.93489473               TRUE           0.9
      341 350  ANCOVA 1 covariate 0.93552709               TRUE           0.9
      342 351  ANCOVA 1 covariate 0.93615377               TRUE           0.9
      343 352  ANCOVA 1 covariate 0.93677482               TRUE           0.9
      344 353  ANCOVA 1 covariate 0.93739027               TRUE           0.9
      345 354  ANCOVA 1 covariate 0.93800018               TRUE           0.9
      346 355  ANCOVA 1 covariate 0.93860459               TRUE           0.9
      347 356  ANCOVA 1 covariate 0.93920354               TRUE           0.9
      348 357  ANCOVA 1 covariate 0.93979707               TRUE           0.9
      349 358  ANCOVA 1 covariate 0.94038523               TRUE           0.9
      350 359  ANCOVA 1 covariate 0.94096807               TRUE           0.9
      351 360  ANCOVA 1 covariate 0.94154562               TRUE           0.9
      352 361  ANCOVA 1 covariate 0.94211792               TRUE           0.9
      353 362  ANCOVA 1 covariate 0.94268503               TRUE           0.9
      354 363  ANCOVA 1 covariate 0.94324697               TRUE           0.9
      355 364  ANCOVA 1 covariate 0.94380380               TRUE           0.9
      356 365  ANCOVA 1 covariate 0.94435555               TRUE           0.9
      357 366  ANCOVA 1 covariate 0.94490227               TRUE           0.9
      358 367  ANCOVA 1 covariate 0.94544399               TRUE           0.9
      359 368  ANCOVA 1 covariate 0.94598076               TRUE           0.9
      360 369  ANCOVA 1 covariate 0.94651262               TRUE           0.9
      361 370  ANCOVA 1 covariate 0.94703960               TRUE           0.9
      362 371  ANCOVA 1 covariate 0.94756175               TRUE           0.9
      363 372  ANCOVA 1 covariate 0.94807911               TRUE           0.9
      364 373  ANCOVA 1 covariate 0.94859171               TRUE           0.9
      365 374  ANCOVA 1 covariate 0.94909960               TRUE           0.9
      366 375  ANCOVA 1 covariate 0.94960281               TRUE           0.9
      367 376  ANCOVA 1 covariate 0.95010138               TRUE           0.9
      368 377  ANCOVA 1 covariate 0.95059535               TRUE           0.9
      369 378  ANCOVA 1 covariate 0.95108476               TRUE           0.9
      370 379  ANCOVA 1 covariate 0.95156965               TRUE           0.9
      371 380  ANCOVA 1 covariate 0.95205005               TRUE           0.9
      372 381  ANCOVA 1 covariate 0.95252600               TRUE           0.9
      373 382  ANCOVA 1 covariate 0.95299753               TRUE           0.9
      374 383  ANCOVA 1 covariate 0.95346470               TRUE           0.9
      375 384  ANCOVA 1 covariate 0.95392752               TRUE           0.9
      376 385  ANCOVA 1 covariate 0.95438604               TRUE           0.9
      377 386  ANCOVA 1 covariate 0.95484029               TRUE           0.9
      378 387  ANCOVA 1 covariate 0.95529032               TRUE           0.9
      379 388  ANCOVA 1 covariate 0.95573614               TRUE           0.9
      380 389  ANCOVA 1 covariate 0.95617781               TRUE           0.9
      381 390  ANCOVA 1 covariate 0.95661535               TRUE           0.9
      382 391  ANCOVA 1 covariate 0.95704880               TRUE           0.9
      383 392  ANCOVA 1 covariate 0.95747820               TRUE           0.9
      384 393  ANCOVA 1 covariate 0.95790357               TRUE           0.9
      385 394  ANCOVA 1 covariate 0.95832496               TRUE           0.9
      386 395  ANCOVA 1 covariate 0.95874239               TRUE           0.9
      387 396  ANCOVA 1 covariate 0.95915591               TRUE           0.9
      388 397  ANCOVA 1 covariate 0.95956553               TRUE           0.9
      389 398  ANCOVA 1 covariate 0.95997130               TRUE           0.9
      390 399  ANCOVA 1 covariate 0.96037326               TRUE           0.9
      391 400  ANCOVA 1 covariate 0.96077142               TRUE           0.9
      392  10 ANCOVA 2 covariates 0.10329687              FALSE           0.9
      393  11 ANCOVA 2 covariates 0.11102187              FALSE           0.9
      394  12 ANCOVA 2 covariates 0.11870499              FALSE           0.9
      395  13 ANCOVA 2 covariates 0.12635732              FALSE           0.9
      396  14 ANCOVA 2 covariates 0.13398654              FALSE           0.9
      397  15 ANCOVA 2 covariates 0.14159797              FALSE           0.9
      398  16 ANCOVA 2 covariates 0.14919526              FALSE           0.9
      399  17 ANCOVA 2 covariates 0.15678081              FALSE           0.9
      400  18 ANCOVA 2 covariates 0.16435616              FALSE           0.9
      401  19 ANCOVA 2 covariates 0.17192213              FALSE           0.9
      402  20 ANCOVA 2 covariates 0.17947905              FALSE           0.9
      403  21 ANCOVA 2 covariates 0.18702685              FALSE           0.9
      404  22 ANCOVA 2 covariates 0.19456515              FALSE           0.9
      405  23 ANCOVA 2 covariates 0.20209335              FALSE           0.9
      406  24 ANCOVA 2 covariates 0.20961068              FALSE           0.9
      407  25 ANCOVA 2 covariates 0.21711621              FALSE           0.9
      408  26 ANCOVA 2 covariates 0.22460892              FALSE           0.9
      409  27 ANCOVA 2 covariates 0.23208773              FALSE           0.9
      410  28 ANCOVA 2 covariates 0.23955146              FALSE           0.9
      411  29 ANCOVA 2 covariates 0.24699893              FALSE           0.9
      412  30 ANCOVA 2 covariates 0.25442892              FALSE           0.9
      413  31 ANCOVA 2 covariates 0.26184019              FALSE           0.9
      414  32 ANCOVA 2 covariates 0.26923151              FALSE           0.9
      415  33 ANCOVA 2 covariates 0.27660164              FALSE           0.9
      416  34 ANCOVA 2 covariates 0.28394934              FALSE           0.9
      417  35 ANCOVA 2 covariates 0.29127340              FALSE           0.9
      418  36 ANCOVA 2 covariates 0.29857261              FALSE           0.9
      419  37 ANCOVA 2 covariates 0.30584580              FALSE           0.9
      420  38 ANCOVA 2 covariates 0.31309181              FALSE           0.9
      421  39 ANCOVA 2 covariates 0.32030950              FALSE           0.9
      422  40 ANCOVA 2 covariates 0.32749776              FALSE           0.9
      423  41 ANCOVA 2 covariates 0.33465552              FALSE           0.9
      424  42 ANCOVA 2 covariates 0.34178173              FALSE           0.9
      425  43 ANCOVA 2 covariates 0.34887537              FALSE           0.9
      426  44 ANCOVA 2 covariates 0.35593544              FALSE           0.9
      427  45 ANCOVA 2 covariates 0.36296099              FALSE           0.9
      428  46 ANCOVA 2 covariates 0.36995110              FALSE           0.9
      429  47 ANCOVA 2 covariates 0.37690487              FALSE           0.9
      430  48 ANCOVA 2 covariates 0.38382144              FALSE           0.9
      431  49 ANCOVA 2 covariates 0.39069997              FALSE           0.9
      432  50 ANCOVA 2 covariates 0.39753966              FALSE           0.9
      433  51 ANCOVA 2 covariates 0.40433976              FALSE           0.9
      434  52 ANCOVA 2 covariates 0.41109951              FALSE           0.9
      435  53 ANCOVA 2 covariates 0.41781822              FALSE           0.9
      436  54 ANCOVA 2 covariates 0.42449520              FALSE           0.9
      437  55 ANCOVA 2 covariates 0.43112982              FALSE           0.9
      438  56 ANCOVA 2 covariates 0.43772145              FALSE           0.9
      439  57 ANCOVA 2 covariates 0.44426951              FALSE           0.9
      440  58 ANCOVA 2 covariates 0.45077344              FALSE           0.9
      441  59 ANCOVA 2 covariates 0.45723271              FALSE           0.9
      442  60 ANCOVA 2 covariates 0.46364682              FALSE           0.9
      443  61 ANCOVA 2 covariates 0.47001528              FALSE           0.9
      444  62 ANCOVA 2 covariates 0.47633767              FALSE           0.9
      445  63 ANCOVA 2 covariates 0.48261354              FALSE           0.9
      446  64 ANCOVA 2 covariates 0.48884251              FALSE           0.9
      447  65 ANCOVA 2 covariates 0.49502420              FALSE           0.9
      448  66 ANCOVA 2 covariates 0.50115827              FALSE           0.9
      449  67 ANCOVA 2 covariates 0.50724439              FALSE           0.9
      450  68 ANCOVA 2 covariates 0.51328226              FALSE           0.9
      451  69 ANCOVA 2 covariates 0.51927162              FALSE           0.9
      452  70 ANCOVA 2 covariates 0.52521220              FALSE           0.9
      453  71 ANCOVA 2 covariates 0.53110377              FALSE           0.9
      454  72 ANCOVA 2 covariates 0.53694612              FALSE           0.9
      455  73 ANCOVA 2 covariates 0.54273907              FALSE           0.9
      456  74 ANCOVA 2 covariates 0.54848243              FALSE           0.9
      457  75 ANCOVA 2 covariates 0.55417607              FALSE           0.9
      458  76 ANCOVA 2 covariates 0.55981985              FALSE           0.9
      459  77 ANCOVA 2 covariates 0.56541366              FALSE           0.9
      460  78 ANCOVA 2 covariates 0.57095741              FALSE           0.9
      461  79 ANCOVA 2 covariates 0.57645102              FALSE           0.9
      462  80 ANCOVA 2 covariates 0.58189444              FALSE           0.9
      463  81 ANCOVA 2 covariates 0.58728761              FALSE           0.9
      464  82 ANCOVA 2 covariates 0.59263052              FALSE           0.9
      465  83 ANCOVA 2 covariates 0.59792316              FALSE           0.9
      466  84 ANCOVA 2 covariates 0.60316553              FALSE           0.9
      467  85 ANCOVA 2 covariates 0.60835765              FALSE           0.9
      468  86 ANCOVA 2 covariates 0.61349956              FALSE           0.9
      469  87 ANCOVA 2 covariates 0.61859131              FALSE           0.9
      470  88 ANCOVA 2 covariates 0.62363296              FALSE           0.9
      471  89 ANCOVA 2 covariates 0.62862458              FALSE           0.9
      472  90 ANCOVA 2 covariates 0.63356627              FALSE           0.9
      473  91 ANCOVA 2 covariates 0.63845813              FALSE           0.9
      474  92 ANCOVA 2 covariates 0.64330027              FALSE           0.9
      475  93 ANCOVA 2 covariates 0.64809282              FALSE           0.9
      476  94 ANCOVA 2 covariates 0.65283590              FALSE           0.9
      477  95 ANCOVA 2 covariates 0.65752968              FALSE           0.9
      478  96 ANCOVA 2 covariates 0.66217430              FALSE           0.9
      479  97 ANCOVA 2 covariates 0.66676993              FALSE           0.9
      480  98 ANCOVA 2 covariates 0.67131674              FALSE           0.9
      481  99 ANCOVA 2 covariates 0.67581494              FALSE           0.9
      482 100 ANCOVA 2 covariates 0.68026470              FALSE           0.9
      483 101 ANCOVA 2 covariates 0.68466624              FALSE           0.9
      484 102 ANCOVA 2 covariates 0.68901977              FALSE           0.9
      485 103 ANCOVA 2 covariates 0.69332550              FALSE           0.9
      486 104 ANCOVA 2 covariates 0.69758367              FALSE           0.9
      487 105 ANCOVA 2 covariates 0.70179451              FALSE           0.9
      488 106 ANCOVA 2 covariates 0.70595826              FALSE           0.9
      489 107 ANCOVA 2 covariates 0.71007517              FALSE           0.9
      490 108 ANCOVA 2 covariates 0.71414550              FALSE           0.9
      491 109 ANCOVA 2 covariates 0.71816950              FALSE           0.9
      492 110 ANCOVA 2 covariates 0.72214746              FALSE           0.9
      493 111 ANCOVA 2 covariates 0.72607963              FALSE           0.9
      494 112 ANCOVA 2 covariates 0.72996631              FALSE           0.9
      495 113 ANCOVA 2 covariates 0.73380776              FALSE           0.9
      496 114 ANCOVA 2 covariates 0.73760429              FALSE           0.9
      497 115 ANCOVA 2 covariates 0.74135619              FALSE           0.9
      498 116 ANCOVA 2 covariates 0.74506375              FALSE           0.9
      499 117 ANCOVA 2 covariates 0.74872728              FALSE           0.9
      500 118 ANCOVA 2 covariates 0.75234708              FALSE           0.9
      501 119 ANCOVA 2 covariates 0.75592346              FALSE           0.9
      502 120 ANCOVA 2 covariates 0.75945674              FALSE           0.9
      503 121 ANCOVA 2 covariates 0.76294723              FALSE           0.9
      504 122 ANCOVA 2 covariates 0.76639525              FALSE           0.9
      505 123 ANCOVA 2 covariates 0.76980113              FALSE           0.9
      506 124 ANCOVA 2 covariates 0.77316519              FALSE           0.9
      507 125 ANCOVA 2 covariates 0.77648776              FALSE           0.9
      508 126 ANCOVA 2 covariates 0.77976917              FALSE           0.9
      509 127 ANCOVA 2 covariates 0.78300975              FALSE           0.9
      510 128 ANCOVA 2 covariates 0.78620984              FALSE           0.9
      511 129 ANCOVA 2 covariates 0.78936977              FALSE           0.9
      512 130 ANCOVA 2 covariates 0.79248988              FALSE           0.9
      513 131 ANCOVA 2 covariates 0.79557052              FALSE           0.9
      514 132 ANCOVA 2 covariates 0.79861201              FALSE           0.9
      515 133 ANCOVA 2 covariates 0.80161471              FALSE           0.9
      516 134 ANCOVA 2 covariates 0.80457896              FALSE           0.9
      517 135 ANCOVA 2 covariates 0.80750509              FALSE           0.9
      518 136 ANCOVA 2 covariates 0.81039346              FALSE           0.9
      519 137 ANCOVA 2 covariates 0.81324442              FALSE           0.9
      520 138 ANCOVA 2 covariates 0.81605829              FALSE           0.9
      521 139 ANCOVA 2 covariates 0.81883545              FALSE           0.9
      522 140 ANCOVA 2 covariates 0.82157622              FALSE           0.9
      523 141 ANCOVA 2 covariates 0.82428096              FALSE           0.9
      524 142 ANCOVA 2 covariates 0.82695001              FALSE           0.9
      525 143 ANCOVA 2 covariates 0.82958372              FALSE           0.9
      526 144 ANCOVA 2 covariates 0.83218243              FALSE           0.9
      527 145 ANCOVA 2 covariates 0.83474650              FALSE           0.9
      528 146 ANCOVA 2 covariates 0.83727627              FALSE           0.9
      529 147 ANCOVA 2 covariates 0.83977207              FALSE           0.9
      530 148 ANCOVA 2 covariates 0.84223427              FALSE           0.9
      531 149 ANCOVA 2 covariates 0.84466320              FALSE           0.9
      532 150 ANCOVA 2 covariates 0.84705920              FALSE           0.9
      533 151 ANCOVA 2 covariates 0.84942261              FALSE           0.9
      534 152 ANCOVA 2 covariates 0.85175379              FALSE           0.9
      535 153 ANCOVA 2 covariates 0.85405306              FALSE           0.9
      536 154 ANCOVA 2 covariates 0.85632077              FALSE           0.9
      537 155 ANCOVA 2 covariates 0.85855725              FALSE           0.9
      538 156 ANCOVA 2 covariates 0.86076285              FALSE           0.9
      539 157 ANCOVA 2 covariates 0.86293789              FALSE           0.9
      540 158 ANCOVA 2 covariates 0.86508271              FALSE           0.9
      541 159 ANCOVA 2 covariates 0.86719765              FALSE           0.9
      542 160 ANCOVA 2 covariates 0.86928303              FALSE           0.9
      543 161 ANCOVA 2 covariates 0.87133918              FALSE           0.9
      544 162 ANCOVA 2 covariates 0.87336644              FALSE           0.9
      545 163 ANCOVA 2 covariates 0.87536513              FALSE           0.9
      546 164 ANCOVA 2 covariates 0.87733557              FALSE           0.9
      547 165 ANCOVA 2 covariates 0.87927808              FALSE           0.9
      548 166 ANCOVA 2 covariates 0.88119299              FALSE           0.9
      549 167 ANCOVA 2 covariates 0.88308062              FALSE           0.9
      550 168 ANCOVA 2 covariates 0.88494128              FALSE           0.9
      551 169 ANCOVA 2 covariates 0.88677529              FALSE           0.9
      552 170 ANCOVA 2 covariates 0.88858296              FALSE           0.9
      553 171 ANCOVA 2 covariates 0.89036460              FALSE           0.9
      554 172 ANCOVA 2 covariates 0.89212052              FALSE           0.9
      555 173 ANCOVA 2 covariates 0.89385104              FALSE           0.9
      556 174 ANCOVA 2 covariates 0.89555645              FALSE           0.9
      557 175 ANCOVA 2 covariates 0.89723705              FALSE           0.9
      558 176 ANCOVA 2 covariates 0.89889315              FALSE           0.9
      559 177 ANCOVA 2 covariates 0.90052505               TRUE           0.9
      560 178 ANCOVA 2 covariates 0.90213305               TRUE           0.9
      561 179 ANCOVA 2 covariates 0.90371743               TRUE           0.9
      562 180 ANCOVA 2 covariates 0.90527849               TRUE           0.9
      563 181 ANCOVA 2 covariates 0.90681651               TRUE           0.9
      564 182 ANCOVA 2 covariates 0.90833180               TRUE           0.9
      565 183 ANCOVA 2 covariates 0.90982462               TRUE           0.9
      566 184 ANCOVA 2 covariates 0.91129527               TRUE           0.9
      567 185 ANCOVA 2 covariates 0.91274402               TRUE           0.9
      568 186 ANCOVA 2 covariates 0.91417115               TRUE           0.9
      569 187 ANCOVA 2 covariates 0.91557694               TRUE           0.9
      570 188 ANCOVA 2 covariates 0.91696166               TRUE           0.9
      571 189 ANCOVA 2 covariates 0.91832558               TRUE           0.9
      572 190 ANCOVA 2 covariates 0.91966897               TRUE           0.9
      573 191 ANCOVA 2 covariates 0.92099209               TRUE           0.9
      574 192 ANCOVA 2 covariates 0.92229522               TRUE           0.9
      575 193 ANCOVA 2 covariates 0.92357860               TRUE           0.9
      576 194 ANCOVA 2 covariates 0.92484250               TRUE           0.9
      577 195 ANCOVA 2 covariates 0.92608718               TRUE           0.9
      578 196 ANCOVA 2 covariates 0.92731289               TRUE           0.9
      579 197 ANCOVA 2 covariates 0.92851987               TRUE           0.9
      580 198 ANCOVA 2 covariates 0.92970839               TRUE           0.9
      581 199 ANCOVA 2 covariates 0.93087868               TRUE           0.9
      582 200 ANCOVA 2 covariates 0.93203099               TRUE           0.9
      583 201 ANCOVA 2 covariates 0.93316556               TRUE           0.9
      584 202 ANCOVA 2 covariates 0.93428264               TRUE           0.9
      585 203 ANCOVA 2 covariates 0.93538245               TRUE           0.9
      586 204 ANCOVA 2 covariates 0.93646523               TRUE           0.9
      587 205 ANCOVA 2 covariates 0.93753122               TRUE           0.9
      588 206 ANCOVA 2 covariates 0.93858064               TRUE           0.9
      589 207 ANCOVA 2 covariates 0.93961372               TRUE           0.9
      590 208 ANCOVA 2 covariates 0.94063069               TRUE           0.9
      591 209 ANCOVA 2 covariates 0.94163177               TRUE           0.9
      592 210 ANCOVA 2 covariates 0.94261717               TRUE           0.9
      593 211 ANCOVA 2 covariates 0.94358712               TRUE           0.9
      594 212 ANCOVA 2 covariates 0.94454183               TRUE           0.9
      595 213 ANCOVA 2 covariates 0.94548151               TRUE           0.9
      596 214 ANCOVA 2 covariates 0.94640638               TRUE           0.9
      597 215 ANCOVA 2 covariates 0.94731664               TRUE           0.9
      598 216 ANCOVA 2 covariates 0.94821250               TRUE           0.9
      599 217 ANCOVA 2 covariates 0.94909417               TRUE           0.9
      600 218 ANCOVA 2 covariates 0.94996183               TRUE           0.9
      601 219 ANCOVA 2 covariates 0.95081570               TRUE           0.9
      602 220 ANCOVA 2 covariates 0.95165596               TRUE           0.9
      603 221 ANCOVA 2 covariates 0.95248282               TRUE           0.9
      604 222 ANCOVA 2 covariates 0.95329647               TRUE           0.9
      605 223 ANCOVA 2 covariates 0.95409709               TRUE           0.9
      606 224 ANCOVA 2 covariates 0.95488488               TRUE           0.9
      607 225 ANCOVA 2 covariates 0.95566001               TRUE           0.9
      608 226 ANCOVA 2 covariates 0.95642267               TRUE           0.9
      609 227 ANCOVA 2 covariates 0.95717305               TRUE           0.9
      610 228 ANCOVA 2 covariates 0.95791132               TRUE           0.9
      611 229 ANCOVA 2 covariates 0.95863766               TRUE           0.9
      612 230 ANCOVA 2 covariates 0.95935224               TRUE           0.9
      613 231 ANCOVA 2 covariates 0.96005524               TRUE           0.9
      614 232 ANCOVA 2 covariates 0.96074683               TRUE           0.9
      615 233 ANCOVA 2 covariates 0.96142717               TRUE           0.9
      616 234 ANCOVA 2 covariates 0.96209642               TRUE           0.9
      617 235 ANCOVA 2 covariates 0.96275477               TRUE           0.9
      618 236 ANCOVA 2 covariates 0.96340236               TRUE           0.9
      619 237 ANCOVA 2 covariates 0.96403936               TRUE           0.9
      620 238 ANCOVA 2 covariates 0.96466592               TRUE           0.9
      621 239 ANCOVA 2 covariates 0.96528220               TRUE           0.9
      622 240 ANCOVA 2 covariates 0.96588836               TRUE           0.9
      623 241 ANCOVA 2 covariates 0.96648455               TRUE           0.9
      624 242 ANCOVA 2 covariates 0.96707091               TRUE           0.9
      625 243 ANCOVA 2 covariates 0.96764760               TRUE           0.9
      626 244 ANCOVA 2 covariates 0.96821476               TRUE           0.9
      627 245 ANCOVA 2 covariates 0.96877253               TRUE           0.9
      628 246 ANCOVA 2 covariates 0.96932107               TRUE           0.9
      629 247 ANCOVA 2 covariates 0.96986050               TRUE           0.9
      630 248 ANCOVA 2 covariates 0.97039097               TRUE           0.9
      631 249 ANCOVA 2 covariates 0.97091262               TRUE           0.9
      632 250 ANCOVA 2 covariates 0.97142557               TRUE           0.9
      633 251 ANCOVA 2 covariates 0.97192997               TRUE           0.9
      634 252 ANCOVA 2 covariates 0.97242595               TRUE           0.9
      635 253 ANCOVA 2 covariates 0.97291362               TRUE           0.9
      636 254 ANCOVA 2 covariates 0.97339313               TRUE           0.9
      637 255 ANCOVA 2 covariates 0.97386460               TRUE           0.9
      638 256 ANCOVA 2 covariates 0.97432816               TRUE           0.9
      639 257 ANCOVA 2 covariates 0.97478392               TRUE           0.9
      640 258 ANCOVA 2 covariates 0.97523200               TRUE           0.9
      641 259 ANCOVA 2 covariates 0.97567254               TRUE           0.9
      642 260 ANCOVA 2 covariates 0.97610564               TRUE           0.9
      643 261 ANCOVA 2 covariates 0.97653142               TRUE           0.9
      644 262 ANCOVA 2 covariates 0.97694999               TRUE           0.9
      645 263 ANCOVA 2 covariates 0.97736148               TRUE           0.9
      646 264 ANCOVA 2 covariates 0.97776599               TRUE           0.9
      647 265 ANCOVA 2 covariates 0.97816362               TRUE           0.9
      648 266 ANCOVA 2 covariates 0.97855450               TRUE           0.9
      649 267 ANCOVA 2 covariates 0.97893872               TRUE           0.9
      650 268 ANCOVA 2 covariates 0.97931640               TRUE           0.9
      651 269 ANCOVA 2 covariates 0.97968763               TRUE           0.9
      652 270 ANCOVA 2 covariates 0.98005252               TRUE           0.9
      653 271 ANCOVA 2 covariates 0.98041117               TRUE           0.9
      654 272 ANCOVA 2 covariates 0.98076367               TRUE           0.9
      655 273 ANCOVA 2 covariates 0.98111013               TRUE           0.9
      656 274 ANCOVA 2 covariates 0.98145065               TRUE           0.9
      657 275 ANCOVA 2 covariates 0.98178531               TRUE           0.9
      658 276 ANCOVA 2 covariates 0.98211422               TRUE           0.9
      659 277 ANCOVA 2 covariates 0.98243747               TRUE           0.9
      660 278 ANCOVA 2 covariates 0.98275513               TRUE           0.9
      661 279 ANCOVA 2 covariates 0.98306732               TRUE           0.9
      662 280 ANCOVA 2 covariates 0.98337411               TRUE           0.9
      663 281 ANCOVA 2 covariates 0.98367560               TRUE           0.9
      664 282 ANCOVA 2 covariates 0.98397186               TRUE           0.9
      665 283 ANCOVA 2 covariates 0.98426299               TRUE           0.9
      666 284 ANCOVA 2 covariates 0.98454906               TRUE           0.9
      667 285 ANCOVA 2 covariates 0.98483016               TRUE           0.9
      668 286 ANCOVA 2 covariates 0.98510637               TRUE           0.9
      669 287 ANCOVA 2 covariates 0.98537778               TRUE           0.9
      670 288 ANCOVA 2 covariates 0.98564445               TRUE           0.9
      671 289 ANCOVA 2 covariates 0.98590647               TRUE           0.9
      672 290 ANCOVA 2 covariates 0.98616391               TRUE           0.9
      673 291 ANCOVA 2 covariates 0.98641685               TRUE           0.9
      674 292 ANCOVA 2 covariates 0.98666536               TRUE           0.9
      675 293 ANCOVA 2 covariates 0.98690952               TRUE           0.9
      676 294 ANCOVA 2 covariates 0.98714940               TRUE           0.9
      677 295 ANCOVA 2 covariates 0.98738506               TRUE           0.9
      678 296 ANCOVA 2 covariates 0.98761658               TRUE           0.9
      679 297 ANCOVA 2 covariates 0.98784403               TRUE           0.9
      680 298 ANCOVA 2 covariates 0.98806748               TRUE           0.9
      681 299 ANCOVA 2 covariates 0.98828698               TRUE           0.9
      682 300 ANCOVA 2 covariates 0.98850261               TRUE           0.9
      683 301 ANCOVA 2 covariates 0.98871443               TRUE           0.9
      684 302 ANCOVA 2 covariates 0.98892250               TRUE           0.9
      685 303 ANCOVA 2 covariates 0.98912690               TRUE           0.9
      686 304 ANCOVA 2 covariates 0.98932767               TRUE           0.9
      687 305 ANCOVA 2 covariates 0.98952488               TRUE           0.9
      688 306 ANCOVA 2 covariates 0.98971859               TRUE           0.9
      689 307 ANCOVA 2 covariates 0.98990886               TRUE           0.9
      690 308 ANCOVA 2 covariates 0.99009574               TRUE           0.9
      691 309 ANCOVA 2 covariates 0.99027930               TRUE           0.9
      692 310 ANCOVA 2 covariates 0.99045959               TRUE           0.9
      693 311 ANCOVA 2 covariates 0.99063666               TRUE           0.9
      694 312 ANCOVA 2 covariates 0.99081057               TRUE           0.9
      695 313 ANCOVA 2 covariates 0.99098138               TRUE           0.9
      696 314 ANCOVA 2 covariates 0.99114913               TRUE           0.9
      697 315 ANCOVA 2 covariates 0.99131387               TRUE           0.9
      698 316 ANCOVA 2 covariates 0.99147567               TRUE           0.9
      699 317 ANCOVA 2 covariates 0.99163456               TRUE           0.9
      700 318 ANCOVA 2 covariates 0.99179060               TRUE           0.9
      701 319 ANCOVA 2 covariates 0.99194384               TRUE           0.9
      702 320 ANCOVA 2 covariates 0.99209432               TRUE           0.9
      703 321 ANCOVA 2 covariates 0.99224210               TRUE           0.9
      704 322 ANCOVA 2 covariates 0.99238721               TRUE           0.9
      705 323 ANCOVA 2 covariates 0.99252971               TRUE           0.9
      706 324 ANCOVA 2 covariates 0.99266963               TRUE           0.9
      707 325 ANCOVA 2 covariates 0.99280703               TRUE           0.9
      708 326 ANCOVA 2 covariates 0.99294194               TRUE           0.9
      709 327 ANCOVA 2 covariates 0.99307441               TRUE           0.9
      710 328 ANCOVA 2 covariates 0.99320449               TRUE           0.9
      711 329 ANCOVA 2 covariates 0.99333220               TRUE           0.9
      712 330 ANCOVA 2 covariates 0.99345760               TRUE           0.9
      713 331 ANCOVA 2 covariates 0.99358073               TRUE           0.9
      714 332 ANCOVA 2 covariates 0.99370161               TRUE           0.9
      715 333 ANCOVA 2 covariates 0.99382030               TRUE           0.9
      716 334 ANCOVA 2 covariates 0.99393683               TRUE           0.9
      717 335 ANCOVA 2 covariates 0.99405124               TRUE           0.9
      718 336 ANCOVA 2 covariates 0.99416356               TRUE           0.9
      719 337 ANCOVA 2 covariates 0.99427383               TRUE           0.9
      720 338 ANCOVA 2 covariates 0.99438209               TRUE           0.9
      721 339 ANCOVA 2 covariates 0.99448837               TRUE           0.9
      722 340 ANCOVA 2 covariates 0.99459270               TRUE           0.9
      723 341 ANCOVA 2 covariates 0.99469513               TRUE           0.9
      724 342 ANCOVA 2 covariates 0.99479568               TRUE           0.9
      725 343 ANCOVA 2 covariates 0.99489438               TRUE           0.9
      726 344 ANCOVA 2 covariates 0.99499128               TRUE           0.9
      727 345 ANCOVA 2 covariates 0.99508640               TRUE           0.9
      728 346 ANCOVA 2 covariates 0.99517976               TRUE           0.9
      729 347 ANCOVA 2 covariates 0.99527141               TRUE           0.9
      730 348 ANCOVA 2 covariates 0.99536138               TRUE           0.9
      731 349 ANCOVA 2 covariates 0.99544969               TRUE           0.9
      732 350 ANCOVA 2 covariates 0.99553637               TRUE           0.9
      733 351 ANCOVA 2 covariates 0.99562145               TRUE           0.9
      734 352 ANCOVA 2 covariates 0.99570496               TRUE           0.9
      735 353 ANCOVA 2 covariates 0.99578692               TRUE           0.9
      736 354 ANCOVA 2 covariates 0.99586737               TRUE           0.9
      737 355 ANCOVA 2 covariates 0.99594634               TRUE           0.9
      738 356 ANCOVA 2 covariates 0.99602384               TRUE           0.9
      739 357 ANCOVA 2 covariates 0.99609990               TRUE           0.9
      740 358 ANCOVA 2 covariates 0.99617456               TRUE           0.9
      741 359 ANCOVA 2 covariates 0.99624782               TRUE           0.9
      742 360 ANCOVA 2 covariates 0.99631973               TRUE           0.9
      743 361 ANCOVA 2 covariates 0.99639030               TRUE           0.9
      744 362 ANCOVA 2 covariates 0.99645956               TRUE           0.9
      745 363 ANCOVA 2 covariates 0.99652753               TRUE           0.9
      746 364 ANCOVA 2 covariates 0.99659423               TRUE           0.9
      747 365 ANCOVA 2 covariates 0.99665969               TRUE           0.9
      748 366 ANCOVA 2 covariates 0.99672393               TRUE           0.9
      749 367 ANCOVA 2 covariates 0.99678697               TRUE           0.9
      750 368 ANCOVA 2 covariates 0.99684884               TRUE           0.9
      751 369 ANCOVA 2 covariates 0.99690954               TRUE           0.9
      752 370 ANCOVA 2 covariates 0.99696911               TRUE           0.9
      753 371 ANCOVA 2 covariates 0.99702757               TRUE           0.9
      754 372 ANCOVA 2 covariates 0.99708493               TRUE           0.9
      755 373 ANCOVA 2 covariates 0.99714121               TRUE           0.9
      756 374 ANCOVA 2 covariates 0.99719644               TRUE           0.9
      757 375 ANCOVA 2 covariates 0.99725063               TRUE           0.9
      758 376 ANCOVA 2 covariates 0.99730381               TRUE           0.9
      759 377 ANCOVA 2 covariates 0.99735598               TRUE           0.9
      760 378 ANCOVA 2 covariates 0.99740718               TRUE           0.9
      761 379 ANCOVA 2 covariates 0.99745741               TRUE           0.9
      762 380 ANCOVA 2 covariates 0.99750669               TRUE           0.9
      763 381 ANCOVA 2 covariates 0.99755505               TRUE           0.9
      764 382 ANCOVA 2 covariates 0.99760249               TRUE           0.9
      765 383 ANCOVA 2 covariates 0.99764904               TRUE           0.9
      766 384 ANCOVA 2 covariates 0.99769471               TRUE           0.9
      767 385 ANCOVA 2 covariates 0.99773951               TRUE           0.9
      768 386 ANCOVA 2 covariates 0.99778347               TRUE           0.9
      769 387 ANCOVA 2 covariates 0.99782660               TRUE           0.9
      770 388 ANCOVA 2 covariates 0.99786891               TRUE           0.9
      771 389 ANCOVA 2 covariates 0.99791042               TRUE           0.9
      772 390 ANCOVA 2 covariates 0.99795114               TRUE           0.9
      773 391 ANCOVA 2 covariates 0.99799109               TRUE           0.9
      774 392 ANCOVA 2 covariates 0.99803028               TRUE           0.9
      775 393 ANCOVA 2 covariates 0.99806873               TRUE           0.9
      776 394 ANCOVA 2 covariates 0.99810644               TRUE           0.9
      777 395 ANCOVA 2 covariates 0.99814344               TRUE           0.9
      778 396 ANCOVA 2 covariates 0.99817973               TRUE           0.9
      779 397 ANCOVA 2 covariates 0.99821534               TRUE           0.9
      780 398 ANCOVA 2 covariates 0.99825026               TRUE           0.9
      781 399 ANCOVA 2 covariates 0.99828452               TRUE           0.9
      782 400 ANCOVA 2 covariates 0.99831812               TRUE           0.9
          samplesize target_effect exposure_prob margin alpha power_fun
      1          782           0.5           0.5      0  0.05  power_gs
      2          782           0.5           0.5      0  0.05  power_gs
      3          782           0.5           0.5      0  0.05  power_gs
      4          782           0.5           0.5      0  0.05  power_gs
      5          782           0.5           0.5      0  0.05  power_gs
      6          782           0.5           0.5      0  0.05  power_gs
      7          782           0.5           0.5      0  0.05  power_gs
      8          782           0.5           0.5      0  0.05  power_gs
      9          782           0.5           0.5      0  0.05  power_gs
      10         782           0.5           0.5      0  0.05  power_gs
      11         782           0.5           0.5      0  0.05  power_gs
      12         782           0.5           0.5      0  0.05  power_gs
      13         782           0.5           0.5      0  0.05  power_gs
      14         782           0.5           0.5      0  0.05  power_gs
      15         782           0.5           0.5      0  0.05  power_gs
      16         782           0.5           0.5      0  0.05  power_gs
      17         782           0.5           0.5      0  0.05  power_gs
      18         782           0.5           0.5      0  0.05  power_gs
      19         782           0.5           0.5      0  0.05  power_gs
      20         782           0.5           0.5      0  0.05  power_gs
      21         782           0.5           0.5      0  0.05  power_gs
      22         782           0.5           0.5      0  0.05  power_gs
      23         782           0.5           0.5      0  0.05  power_gs
      24         782           0.5           0.5      0  0.05  power_gs
      25         782           0.5           0.5      0  0.05  power_gs
      26         782           0.5           0.5      0  0.05  power_gs
      27         782           0.5           0.5      0  0.05  power_gs
      28         782           0.5           0.5      0  0.05  power_gs
      29         782           0.5           0.5      0  0.05  power_gs
      30         782           0.5           0.5      0  0.05  power_gs
      31         782           0.5           0.5      0  0.05  power_gs
      32         782           0.5           0.5      0  0.05  power_gs
      33         782           0.5           0.5      0  0.05  power_gs
      34         782           0.5           0.5      0  0.05  power_gs
      35         782           0.5           0.5      0  0.05  power_gs
      36         782           0.5           0.5      0  0.05  power_gs
      37         782           0.5           0.5      0  0.05  power_gs
      38         782           0.5           0.5      0  0.05  power_gs
      39         782           0.5           0.5      0  0.05  power_gs
      40         782           0.5           0.5      0  0.05  power_gs
      41         782           0.5           0.5      0  0.05  power_gs
      42         782           0.5           0.5      0  0.05  power_gs
      43         782           0.5           0.5      0  0.05  power_gs
      44         782           0.5           0.5      0  0.05  power_gs
      45         782           0.5           0.5      0  0.05  power_gs
      46         782           0.5           0.5      0  0.05  power_gs
      47         782           0.5           0.5      0  0.05  power_gs
      48         782           0.5           0.5      0  0.05  power_gs
      49         782           0.5           0.5      0  0.05  power_gs
      50         782           0.5           0.5      0  0.05  power_gs
      51         782           0.5           0.5      0  0.05  power_gs
      52         782           0.5           0.5      0  0.05  power_gs
      53         782           0.5           0.5      0  0.05  power_gs
      54         782           0.5           0.5      0  0.05  power_gs
      55         782           0.5           0.5      0  0.05  power_gs
      56         782           0.5           0.5      0  0.05  power_gs
      57         782           0.5           0.5      0  0.05  power_gs
      58         782           0.5           0.5      0  0.05  power_gs
      59         782           0.5           0.5      0  0.05  power_gs
      60         782           0.5           0.5      0  0.05  power_gs
      61         782           0.5           0.5      0  0.05  power_gs
      62         782           0.5           0.5      0  0.05  power_gs
      63         782           0.5           0.5      0  0.05  power_gs
      64         782           0.5           0.5      0  0.05  power_gs
      65         782           0.5           0.5      0  0.05  power_gs
      66         782           0.5           0.5      0  0.05  power_gs
      67         782           0.5           0.5      0  0.05  power_gs
      68         782           0.5           0.5      0  0.05  power_gs
      69         782           0.5           0.5      0  0.05  power_gs
      70         782           0.5           0.5      0  0.05  power_gs
      71         782           0.5           0.5      0  0.05  power_gs
      72         782           0.5           0.5      0  0.05  power_gs
      73         782           0.5           0.5      0  0.05  power_gs
      74         782           0.5           0.5      0  0.05  power_gs
      75         782           0.5           0.5      0  0.05  power_gs
      76         782           0.5           0.5      0  0.05  power_gs
      77         782           0.5           0.5      0  0.05  power_gs
      78         782           0.5           0.5      0  0.05  power_gs
      79         782           0.5           0.5      0  0.05  power_gs
      80         782           0.5           0.5      0  0.05  power_gs
      81         782           0.5           0.5      0  0.05  power_gs
      82         782           0.5           0.5      0  0.05  power_gs
      83         782           0.5           0.5      0  0.05  power_gs
      84         782           0.5           0.5      0  0.05  power_gs
      85         782           0.5           0.5      0  0.05  power_gs
      86         782           0.5           0.5      0  0.05  power_gs
      87         782           0.5           0.5      0  0.05  power_gs
      88         782           0.5           0.5      0  0.05  power_gs
      89         782           0.5           0.5      0  0.05  power_gs
      90         782           0.5           0.5      0  0.05  power_gs
      91         782           0.5           0.5      0  0.05  power_gs
      92         782           0.5           0.5      0  0.05  power_gs
      93         782           0.5           0.5      0  0.05  power_gs
      94         782           0.5           0.5      0  0.05  power_gs
      95         782           0.5           0.5      0  0.05  power_gs
      96         782           0.5           0.5      0  0.05  power_gs
      97         782           0.5           0.5      0  0.05  power_gs
      98         782           0.5           0.5      0  0.05  power_gs
      99         782           0.5           0.5      0  0.05  power_gs
      100        782           0.5           0.5      0  0.05  power_gs
      101        782           0.5           0.5      0  0.05  power_gs
      102        782           0.5           0.5      0  0.05  power_gs
      103        782           0.5           0.5      0  0.05  power_gs
      104        782           0.5           0.5      0  0.05  power_gs
      105        782           0.5           0.5      0  0.05  power_gs
      106        782           0.5           0.5      0  0.05  power_gs
      107        782           0.5           0.5      0  0.05  power_gs
      108        782           0.5           0.5      0  0.05  power_gs
      109        782           0.5           0.5      0  0.05  power_gs
      110        782           0.5           0.5      0  0.05  power_gs
      111        782           0.5           0.5      0  0.05  power_gs
      112        782           0.5           0.5      0  0.05  power_gs
      113        782           0.5           0.5      0  0.05  power_gs
      114        782           0.5           0.5      0  0.05  power_gs
      115        782           0.5           0.5      0  0.05  power_gs
      116        782           0.5           0.5      0  0.05  power_gs
      117        782           0.5           0.5      0  0.05  power_gs
      118        782           0.5           0.5      0  0.05  power_gs
      119        782           0.5           0.5      0  0.05  power_gs
      120        782           0.5           0.5      0  0.05  power_gs
      121        782           0.5           0.5      0  0.05  power_gs
      122        782           0.5           0.5      0  0.05  power_gs
      123        782           0.5           0.5      0  0.05  power_gs
      124        782           0.5           0.5      0  0.05  power_gs
      125        782           0.5           0.5      0  0.05  power_gs
      126        782           0.5           0.5      0  0.05  power_gs
      127        782           0.5           0.5      0  0.05  power_gs
      128        782           0.5           0.5      0  0.05  power_gs
      129        782           0.5           0.5      0  0.05  power_gs
      130        782           0.5           0.5      0  0.05  power_gs
      131        782           0.5           0.5      0  0.05  power_gs
      132        782           0.5           0.5      0  0.05  power_gs
      133        782           0.5           0.5      0  0.05  power_gs
      134        782           0.5           0.5      0  0.05  power_gs
      135        782           0.5           0.5      0  0.05  power_gs
      136        782           0.5           0.5      0  0.05  power_gs
      137        782           0.5           0.5      0  0.05  power_gs
      138        782           0.5           0.5      0  0.05  power_gs
      139        782           0.5           0.5      0  0.05  power_gs
      140        782           0.5           0.5      0  0.05  power_gs
      141        782           0.5           0.5      0  0.05  power_gs
      142        782           0.5           0.5      0  0.05  power_gs
      143        782           0.5           0.5      0  0.05  power_gs
      144        782           0.5           0.5      0  0.05  power_gs
      145        782           0.5           0.5      0  0.05  power_gs
      146        782           0.5           0.5      0  0.05  power_gs
      147        782           0.5           0.5      0  0.05  power_gs
      148        782           0.5           0.5      0  0.05  power_gs
      149        782           0.5           0.5      0  0.05  power_gs
      150        782           0.5           0.5      0  0.05  power_gs
      151        782           0.5           0.5      0  0.05  power_gs
      152        782           0.5           0.5      0  0.05  power_gs
      153        782           0.5           0.5      0  0.05  power_gs
      154        782           0.5           0.5      0  0.05  power_gs
      155        782           0.5           0.5      0  0.05  power_gs
      156        782           0.5           0.5      0  0.05  power_gs
      157        782           0.5           0.5      0  0.05  power_gs
      158        782           0.5           0.5      0  0.05  power_gs
      159        782           0.5           0.5      0  0.05  power_gs
      160        782           0.5           0.5      0  0.05  power_gs
      161        782           0.5           0.5      0  0.05  power_gs
      162        782           0.5           0.5      0  0.05  power_gs
      163        782           0.5           0.5      0  0.05  power_gs
      164        782           0.5           0.5      0  0.05  power_gs
      165        782           0.5           0.5      0  0.05  power_gs
      166        782           0.5           0.5      0  0.05  power_gs
      167        782           0.5           0.5      0  0.05  power_gs
      168        782           0.5           0.5      0  0.05  power_gs
      169        782           0.5           0.5      0  0.05  power_gs
      170        782           0.5           0.5      0  0.05  power_gs
      171        782           0.5           0.5      0  0.05  power_gs
      172        782           0.5           0.5      0  0.05  power_gs
      173        782           0.5           0.5      0  0.05  power_gs
      174        782           0.5           0.5      0  0.05  power_gs
      175        782           0.5           0.5      0  0.05  power_gs
      176        782           0.5           0.5      0  0.05  power_gs
      177        782           0.5           0.5      0  0.05  power_gs
      178        782           0.5           0.5      0  0.05  power_gs
      179        782           0.5           0.5      0  0.05  power_gs
      180        782           0.5           0.5      0  0.05  power_gs
      181        782           0.5           0.5      0  0.05  power_gs
      182        782           0.5           0.5      0  0.05  power_gs
      183        782           0.5           0.5      0  0.05  power_gs
      184        782           0.5           0.5      0  0.05  power_gs
      185        782           0.5           0.5      0  0.05  power_gs
      186        782           0.5           0.5      0  0.05  power_gs
      187        782           0.5           0.5      0  0.05  power_gs
      188        782           0.5           0.5      0  0.05  power_gs
      189        782           0.5           0.5      0  0.05  power_gs
      190        782           0.5           0.5      0  0.05  power_gs
      191        782           0.5           0.5      0  0.05  power_gs
      192        782           0.5           0.5      0  0.05  power_gs
      193        782           0.5           0.5      0  0.05  power_gs
      194        782           0.5           0.5      0  0.05  power_gs
      195        782           0.5           0.5      0  0.05  power_gs
      196        782           0.5           0.5      0  0.05  power_gs
      197        782           0.5           0.5      0  0.05  power_gs
      198        782           0.5           0.5      0  0.05  power_gs
      199        782           0.5           0.5      0  0.05  power_gs
      200        782           0.5           0.5      0  0.05  power_gs
      201        782           0.5           0.5      0  0.05  power_gs
      202        782           0.5           0.5      0  0.05  power_gs
      203        782           0.5           0.5      0  0.05  power_gs
      204        782           0.5           0.5      0  0.05  power_gs
      205        782           0.5           0.5      0  0.05  power_gs
      206        782           0.5           0.5      0  0.05  power_gs
      207        782           0.5           0.5      0  0.05  power_gs
      208        782           0.5           0.5      0  0.05  power_gs
      209        782           0.5           0.5      0  0.05  power_gs
      210        782           0.5           0.5      0  0.05  power_gs
      211        782           0.5           0.5      0  0.05  power_gs
      212        782           0.5           0.5      0  0.05  power_gs
      213        782           0.5           0.5      0  0.05  power_gs
      214        782           0.5           0.5      0  0.05  power_gs
      215        782           0.5           0.5      0  0.05  power_gs
      216        782           0.5           0.5      0  0.05  power_gs
      217        782           0.5           0.5      0  0.05  power_gs
      218        782           0.5           0.5      0  0.05  power_gs
      219        782           0.5           0.5      0  0.05  power_gs
      220        782           0.5           0.5      0  0.05  power_gs
      221        782           0.5           0.5      0  0.05  power_gs
      222        782           0.5           0.5      0  0.05  power_gs
      223        782           0.5           0.5      0  0.05  power_gs
      224        782           0.5           0.5      0  0.05  power_gs
      225        782           0.5           0.5      0  0.05  power_gs
      226        782           0.5           0.5      0  0.05  power_gs
      227        782           0.5           0.5      0  0.05  power_gs
      228        782           0.5           0.5      0  0.05  power_gs
      229        782           0.5           0.5      0  0.05  power_gs
      230        782           0.5           0.5      0  0.05  power_gs
      231        782           0.5           0.5      0  0.05  power_gs
      232        782           0.5           0.5      0  0.05  power_gs
      233        782           0.5           0.5      0  0.05  power_gs
      234        782           0.5           0.5      0  0.05  power_gs
      235        782           0.5           0.5      0  0.05  power_gs
      236        782           0.5           0.5      0  0.05  power_gs
      237        782           0.5           0.5      0  0.05  power_gs
      238        782           0.5           0.5      0  0.05  power_gs
      239        782           0.5           0.5      0  0.05  power_gs
      240        782           0.5           0.5      0  0.05  power_gs
      241        782           0.5           0.5      0  0.05  power_gs
      242        782           0.5           0.5      0  0.05  power_gs
      243        782           0.5           0.5      0  0.05  power_gs
      244        782           0.5           0.5      0  0.05  power_gs
      245        782           0.5           0.5      0  0.05  power_gs
      246        782           0.5           0.5      0  0.05  power_gs
      247        782           0.5           0.5      0  0.05  power_gs
      248        782           0.5           0.5      0  0.05  power_gs
      249        782           0.5           0.5      0  0.05  power_gs
      250        782           0.5           0.5      0  0.05  power_gs
      251        782           0.5           0.5      0  0.05  power_gs
      252        782           0.5           0.5      0  0.05  power_gs
      253        782           0.5           0.5      0  0.05  power_gs
      254        782           0.5           0.5      0  0.05  power_gs
      255        782           0.5           0.5      0  0.05  power_gs
      256        782           0.5           0.5      0  0.05  power_gs
      257        782           0.5           0.5      0  0.05  power_gs
      258        782           0.5           0.5      0  0.05  power_gs
      259        782           0.5           0.5      0  0.05  power_gs
      260        782           0.5           0.5      0  0.05  power_gs
      261        782           0.5           0.5      0  0.05  power_gs
      262        782           0.5           0.5      0  0.05  power_gs
      263        782           0.5           0.5      0  0.05  power_gs
      264        782           0.5           0.5      0  0.05  power_gs
      265        782           0.5           0.5      0  0.05  power_gs
      266        782           0.5           0.5      0  0.05  power_gs
      267        782           0.5           0.5      0  0.05  power_gs
      268        782           0.5           0.5      0  0.05  power_gs
      269        782           0.5           0.5      0  0.05  power_gs
      270        782           0.5           0.5      0  0.05  power_gs
      271        782           0.5           0.5      0  0.05  power_gs
      272        782           0.5           0.5      0  0.05  power_gs
      273        782           0.5           0.5      0  0.05  power_gs
      274        782           0.5           0.5      0  0.05  power_gs
      275        782           0.5           0.5      0  0.05  power_gs
      276        782           0.5           0.5      0  0.05  power_gs
      277        782           0.5           0.5      0  0.05  power_gs
      278        782           0.5           0.5      0  0.05  power_gs
      279        782           0.5           0.5      0  0.05  power_gs
      280        782           0.5           0.5      0  0.05  power_gs
      281        782           0.5           0.5      0  0.05  power_gs
      282        782           0.5           0.5      0  0.05  power_gs
      283        782           0.5           0.5      0  0.05  power_gs
      284        782           0.5           0.5      0  0.05  power_gs
      285        782           0.5           0.5      0  0.05  power_gs
      286        782           0.5           0.5      0  0.05  power_gs
      287        782           0.5           0.5      0  0.05  power_gs
      288        782           0.5           0.5      0  0.05  power_gs
      289        782           0.5           0.5      0  0.05  power_gs
      290        782           0.5           0.5      0  0.05  power_gs
      291        782           0.5           0.5      0  0.05  power_gs
      292        782           0.5           0.5      0  0.05  power_gs
      293        782           0.5           0.5      0  0.05  power_gs
      294        782           0.5           0.5      0  0.05  power_gs
      295        782           0.5           0.5      0  0.05  power_gs
      296        782           0.5           0.5      0  0.05  power_gs
      297        782           0.5           0.5      0  0.05  power_gs
      298        782           0.5           0.5      0  0.05  power_gs
      299        782           0.5           0.5      0  0.05  power_gs
      300        782           0.5           0.5      0  0.05  power_gs
      301        782           0.5           0.5      0  0.05  power_gs
      302        782           0.5           0.5      0  0.05  power_gs
      303        782           0.5           0.5      0  0.05  power_gs
      304        782           0.5           0.5      0  0.05  power_gs
      305        782           0.5           0.5      0  0.05  power_gs
      306        782           0.5           0.5      0  0.05  power_gs
      307        782           0.5           0.5      0  0.05  power_gs
      308        782           0.5           0.5      0  0.05  power_gs
      309        782           0.5           0.5      0  0.05  power_gs
      310        782           0.5           0.5      0  0.05  power_gs
      311        782           0.5           0.5      0  0.05  power_gs
      312        782           0.5           0.5      0  0.05  power_gs
      313        782           0.5           0.5      0  0.05  power_gs
      314        782           0.5           0.5      0  0.05  power_gs
      315        782           0.5           0.5      0  0.05  power_gs
      316        782           0.5           0.5      0  0.05  power_gs
      317        782           0.5           0.5      0  0.05  power_gs
      318        782           0.5           0.5      0  0.05  power_gs
      319        782           0.5           0.5      0  0.05  power_gs
      320        782           0.5           0.5      0  0.05  power_gs
      321        782           0.5           0.5      0  0.05  power_gs
      322        782           0.5           0.5      0  0.05  power_gs
      323        782           0.5           0.5      0  0.05  power_gs
      324        782           0.5           0.5      0  0.05  power_gs
      325        782           0.5           0.5      0  0.05  power_gs
      326        782           0.5           0.5      0  0.05  power_gs
      327        782           0.5           0.5      0  0.05  power_gs
      328        782           0.5           0.5      0  0.05  power_gs
      329        782           0.5           0.5      0  0.05  power_gs
      330        782           0.5           0.5      0  0.05  power_gs
      331        782           0.5           0.5      0  0.05  power_gs
      332        782           0.5           0.5      0  0.05  power_gs
      333        782           0.5           0.5      0  0.05  power_gs
      334        782           0.5           0.5      0  0.05  power_gs
      335        782           0.5           0.5      0  0.05  power_gs
      336        782           0.5           0.5      0  0.05  power_gs
      337        782           0.5           0.5      0  0.05  power_gs
      338        782           0.5           0.5      0  0.05  power_gs
      339        782           0.5           0.5      0  0.05  power_gs
      340        782           0.5           0.5      0  0.05  power_gs
      341        782           0.5           0.5      0  0.05  power_gs
      342        782           0.5           0.5      0  0.05  power_gs
      343        782           0.5           0.5      0  0.05  power_gs
      344        782           0.5           0.5      0  0.05  power_gs
      345        782           0.5           0.5      0  0.05  power_gs
      346        782           0.5           0.5      0  0.05  power_gs
      347        782           0.5           0.5      0  0.05  power_gs
      348        782           0.5           0.5      0  0.05  power_gs
      349        782           0.5           0.5      0  0.05  power_gs
      350        782           0.5           0.5      0  0.05  power_gs
      351        782           0.5           0.5      0  0.05  power_gs
      352        782           0.5           0.5      0  0.05  power_gs
      353        782           0.5           0.5      0  0.05  power_gs
      354        782           0.5           0.5      0  0.05  power_gs
      355        782           0.5           0.5      0  0.05  power_gs
      356        782           0.5           0.5      0  0.05  power_gs
      357        782           0.5           0.5      0  0.05  power_gs
      358        782           0.5           0.5      0  0.05  power_gs
      359        782           0.5           0.5      0  0.05  power_gs
      360        782           0.5           0.5      0  0.05  power_gs
      361        782           0.5           0.5      0  0.05  power_gs
      362        782           0.5           0.5      0  0.05  power_gs
      363        782           0.5           0.5      0  0.05  power_gs
      364        782           0.5           0.5      0  0.05  power_gs
      365        782           0.5           0.5      0  0.05  power_gs
      366        782           0.5           0.5      0  0.05  power_gs
      367        782           0.5           0.5      0  0.05  power_gs
      368        782           0.5           0.5      0  0.05  power_gs
      369        782           0.5           0.5      0  0.05  power_gs
      370        782           0.5           0.5      0  0.05  power_gs
      371        782           0.5           0.5      0  0.05  power_gs
      372        782           0.5           0.5      0  0.05  power_gs
      373        782           0.5           0.5      0  0.05  power_gs
      374        782           0.5           0.5      0  0.05  power_gs
      375        782           0.5           0.5      0  0.05  power_gs
      376        782           0.5           0.5      0  0.05  power_gs
      377        782           0.5           0.5      0  0.05  power_gs
      378        782           0.5           0.5      0  0.05  power_gs
      379        782           0.5           0.5      0  0.05  power_gs
      380        782           0.5           0.5      0  0.05  power_gs
      381        782           0.5           0.5      0  0.05  power_gs
      382        782           0.5           0.5      0  0.05  power_gs
      383        782           0.5           0.5      0  0.05  power_gs
      384        782           0.5           0.5      0  0.05  power_gs
      385        782           0.5           0.5      0  0.05  power_gs
      386        782           0.5           0.5      0  0.05  power_gs
      387        782           0.5           0.5      0  0.05  power_gs
      388        782           0.5           0.5      0  0.05  power_gs
      389        782           0.5           0.5      0  0.05  power_gs
      390        782           0.5           0.5      0  0.05  power_gs
      391        782           0.5           0.5      0  0.05  power_gs
      392        782           0.5           0.5      0  0.05  power_gs
      393        782           0.5           0.5      0  0.05  power_gs
      394        782           0.5           0.5      0  0.05  power_gs
      395        782           0.5           0.5      0  0.05  power_gs
      396        782           0.5           0.5      0  0.05  power_gs
      397        782           0.5           0.5      0  0.05  power_gs
      398        782           0.5           0.5      0  0.05  power_gs
      399        782           0.5           0.5      0  0.05  power_gs
      400        782           0.5           0.5      0  0.05  power_gs
      401        782           0.5           0.5      0  0.05  power_gs
      402        782           0.5           0.5      0  0.05  power_gs
      403        782           0.5           0.5      0  0.05  power_gs
      404        782           0.5           0.5      0  0.05  power_gs
      405        782           0.5           0.5      0  0.05  power_gs
      406        782           0.5           0.5      0  0.05  power_gs
      407        782           0.5           0.5      0  0.05  power_gs
      408        782           0.5           0.5      0  0.05  power_gs
      409        782           0.5           0.5      0  0.05  power_gs
      410        782           0.5           0.5      0  0.05  power_gs
      411        782           0.5           0.5      0  0.05  power_gs
      412        782           0.5           0.5      0  0.05  power_gs
      413        782           0.5           0.5      0  0.05  power_gs
      414        782           0.5           0.5      0  0.05  power_gs
      415        782           0.5           0.5      0  0.05  power_gs
      416        782           0.5           0.5      0  0.05  power_gs
      417        782           0.5           0.5      0  0.05  power_gs
      418        782           0.5           0.5      0  0.05  power_gs
      419        782           0.5           0.5      0  0.05  power_gs
      420        782           0.5           0.5      0  0.05  power_gs
      421        782           0.5           0.5      0  0.05  power_gs
      422        782           0.5           0.5      0  0.05  power_gs
      423        782           0.5           0.5      0  0.05  power_gs
      424        782           0.5           0.5      0  0.05  power_gs
      425        782           0.5           0.5      0  0.05  power_gs
      426        782           0.5           0.5      0  0.05  power_gs
      427        782           0.5           0.5      0  0.05  power_gs
      428        782           0.5           0.5      0  0.05  power_gs
      429        782           0.5           0.5      0  0.05  power_gs
      430        782           0.5           0.5      0  0.05  power_gs
      431        782           0.5           0.5      0  0.05  power_gs
      432        782           0.5           0.5      0  0.05  power_gs
      433        782           0.5           0.5      0  0.05  power_gs
      434        782           0.5           0.5      0  0.05  power_gs
      435        782           0.5           0.5      0  0.05  power_gs
      436        782           0.5           0.5      0  0.05  power_gs
      437        782           0.5           0.5      0  0.05  power_gs
      438        782           0.5           0.5      0  0.05  power_gs
      439        782           0.5           0.5      0  0.05  power_gs
      440        782           0.5           0.5      0  0.05  power_gs
      441        782           0.5           0.5      0  0.05  power_gs
      442        782           0.5           0.5      0  0.05  power_gs
      443        782           0.5           0.5      0  0.05  power_gs
      444        782           0.5           0.5      0  0.05  power_gs
      445        782           0.5           0.5      0  0.05  power_gs
      446        782           0.5           0.5      0  0.05  power_gs
      447        782           0.5           0.5      0  0.05  power_gs
      448        782           0.5           0.5      0  0.05  power_gs
      449        782           0.5           0.5      0  0.05  power_gs
      450        782           0.5           0.5      0  0.05  power_gs
      451        782           0.5           0.5      0  0.05  power_gs
      452        782           0.5           0.5      0  0.05  power_gs
      453        782           0.5           0.5      0  0.05  power_gs
      454        782           0.5           0.5      0  0.05  power_gs
      455        782           0.5           0.5      0  0.05  power_gs
      456        782           0.5           0.5      0  0.05  power_gs
      457        782           0.5           0.5      0  0.05  power_gs
      458        782           0.5           0.5      0  0.05  power_gs
      459        782           0.5           0.5      0  0.05  power_gs
      460        782           0.5           0.5      0  0.05  power_gs
      461        782           0.5           0.5      0  0.05  power_gs
      462        782           0.5           0.5      0  0.05  power_gs
      463        782           0.5           0.5      0  0.05  power_gs
      464        782           0.5           0.5      0  0.05  power_gs
      465        782           0.5           0.5      0  0.05  power_gs
      466        782           0.5           0.5      0  0.05  power_gs
      467        782           0.5           0.5      0  0.05  power_gs
      468        782           0.5           0.5      0  0.05  power_gs
      469        782           0.5           0.5      0  0.05  power_gs
      470        782           0.5           0.5      0  0.05  power_gs
      471        782           0.5           0.5      0  0.05  power_gs
      472        782           0.5           0.5      0  0.05  power_gs
      473        782           0.5           0.5      0  0.05  power_gs
      474        782           0.5           0.5      0  0.05  power_gs
      475        782           0.5           0.5      0  0.05  power_gs
      476        782           0.5           0.5      0  0.05  power_gs
      477        782           0.5           0.5      0  0.05  power_gs
      478        782           0.5           0.5      0  0.05  power_gs
      479        782           0.5           0.5      0  0.05  power_gs
      480        782           0.5           0.5      0  0.05  power_gs
      481        782           0.5           0.5      0  0.05  power_gs
      482        782           0.5           0.5      0  0.05  power_gs
      483        782           0.5           0.5      0  0.05  power_gs
      484        782           0.5           0.5      0  0.05  power_gs
      485        782           0.5           0.5      0  0.05  power_gs
      486        782           0.5           0.5      0  0.05  power_gs
      487        782           0.5           0.5      0  0.05  power_gs
      488        782           0.5           0.5      0  0.05  power_gs
      489        782           0.5           0.5      0  0.05  power_gs
      490        782           0.5           0.5      0  0.05  power_gs
      491        782           0.5           0.5      0  0.05  power_gs
      492        782           0.5           0.5      0  0.05  power_gs
      493        782           0.5           0.5      0  0.05  power_gs
      494        782           0.5           0.5      0  0.05  power_gs
      495        782           0.5           0.5      0  0.05  power_gs
      496        782           0.5           0.5      0  0.05  power_gs
      497        782           0.5           0.5      0  0.05  power_gs
      498        782           0.5           0.5      0  0.05  power_gs
      499        782           0.5           0.5      0  0.05  power_gs
      500        782           0.5           0.5      0  0.05  power_gs
      501        782           0.5           0.5      0  0.05  power_gs
      502        782           0.5           0.5      0  0.05  power_gs
      503        782           0.5           0.5      0  0.05  power_gs
      504        782           0.5           0.5      0  0.05  power_gs
      505        782           0.5           0.5      0  0.05  power_gs
      506        782           0.5           0.5      0  0.05  power_gs
      507        782           0.5           0.5      0  0.05  power_gs
      508        782           0.5           0.5      0  0.05  power_gs
      509        782           0.5           0.5      0  0.05  power_gs
      510        782           0.5           0.5      0  0.05  power_gs
      511        782           0.5           0.5      0  0.05  power_gs
      512        782           0.5           0.5      0  0.05  power_gs
      513        782           0.5           0.5      0  0.05  power_gs
      514        782           0.5           0.5      0  0.05  power_gs
      515        782           0.5           0.5      0  0.05  power_gs
      516        782           0.5           0.5      0  0.05  power_gs
      517        782           0.5           0.5      0  0.05  power_gs
      518        782           0.5           0.5      0  0.05  power_gs
      519        782           0.5           0.5      0  0.05  power_gs
      520        782           0.5           0.5      0  0.05  power_gs
      521        782           0.5           0.5      0  0.05  power_gs
      522        782           0.5           0.5      0  0.05  power_gs
      523        782           0.5           0.5      0  0.05  power_gs
      524        782           0.5           0.5      0  0.05  power_gs
      525        782           0.5           0.5      0  0.05  power_gs
      526        782           0.5           0.5      0  0.05  power_gs
      527        782           0.5           0.5      0  0.05  power_gs
      528        782           0.5           0.5      0  0.05  power_gs
      529        782           0.5           0.5      0  0.05  power_gs
      530        782           0.5           0.5      0  0.05  power_gs
      531        782           0.5           0.5      0  0.05  power_gs
      532        782           0.5           0.5      0  0.05  power_gs
      533        782           0.5           0.5      0  0.05  power_gs
      534        782           0.5           0.5      0  0.05  power_gs
      535        782           0.5           0.5      0  0.05  power_gs
      536        782           0.5           0.5      0  0.05  power_gs
      537        782           0.5           0.5      0  0.05  power_gs
      538        782           0.5           0.5      0  0.05  power_gs
      539        782           0.5           0.5      0  0.05  power_gs
      540        782           0.5           0.5      0  0.05  power_gs
      541        782           0.5           0.5      0  0.05  power_gs
      542        782           0.5           0.5      0  0.05  power_gs
      543        782           0.5           0.5      0  0.05  power_gs
      544        782           0.5           0.5      0  0.05  power_gs
      545        782           0.5           0.5      0  0.05  power_gs
      546        782           0.5           0.5      0  0.05  power_gs
      547        782           0.5           0.5      0  0.05  power_gs
      548        782           0.5           0.5      0  0.05  power_gs
      549        782           0.5           0.5      0  0.05  power_gs
      550        782           0.5           0.5      0  0.05  power_gs
      551        782           0.5           0.5      0  0.05  power_gs
      552        782           0.5           0.5      0  0.05  power_gs
      553        782           0.5           0.5      0  0.05  power_gs
      554        782           0.5           0.5      0  0.05  power_gs
      555        782           0.5           0.5      0  0.05  power_gs
      556        782           0.5           0.5      0  0.05  power_gs
      557        782           0.5           0.5      0  0.05  power_gs
      558        782           0.5           0.5      0  0.05  power_gs
      559        782           0.5           0.5      0  0.05  power_gs
      560        782           0.5           0.5      0  0.05  power_gs
      561        782           0.5           0.5      0  0.05  power_gs
      562        782           0.5           0.5      0  0.05  power_gs
      563        782           0.5           0.5      0  0.05  power_gs
      564        782           0.5           0.5      0  0.05  power_gs
      565        782           0.5           0.5      0  0.05  power_gs
      566        782           0.5           0.5      0  0.05  power_gs
      567        782           0.5           0.5      0  0.05  power_gs
      568        782           0.5           0.5      0  0.05  power_gs
      569        782           0.5           0.5      0  0.05  power_gs
      570        782           0.5           0.5      0  0.05  power_gs
      571        782           0.5           0.5      0  0.05  power_gs
      572        782           0.5           0.5      0  0.05  power_gs
      573        782           0.5           0.5      0  0.05  power_gs
      574        782           0.5           0.5      0  0.05  power_gs
      575        782           0.5           0.5      0  0.05  power_gs
      576        782           0.5           0.5      0  0.05  power_gs
      577        782           0.5           0.5      0  0.05  power_gs
      578        782           0.5           0.5      0  0.05  power_gs
      579        782           0.5           0.5      0  0.05  power_gs
      580        782           0.5           0.5      0  0.05  power_gs
      581        782           0.5           0.5      0  0.05  power_gs
      582        782           0.5           0.5      0  0.05  power_gs
      583        782           0.5           0.5      0  0.05  power_gs
      584        782           0.5           0.5      0  0.05  power_gs
      585        782           0.5           0.5      0  0.05  power_gs
      586        782           0.5           0.5      0  0.05  power_gs
      587        782           0.5           0.5      0  0.05  power_gs
      588        782           0.5           0.5      0  0.05  power_gs
      589        782           0.5           0.5      0  0.05  power_gs
      590        782           0.5           0.5      0  0.05  power_gs
      591        782           0.5           0.5      0  0.05  power_gs
      592        782           0.5           0.5      0  0.05  power_gs
      593        782           0.5           0.5      0  0.05  power_gs
      594        782           0.5           0.5      0  0.05  power_gs
      595        782           0.5           0.5      0  0.05  power_gs
      596        782           0.5           0.5      0  0.05  power_gs
      597        782           0.5           0.5      0  0.05  power_gs
      598        782           0.5           0.5      0  0.05  power_gs
      599        782           0.5           0.5      0  0.05  power_gs
      600        782           0.5           0.5      0  0.05  power_gs
      601        782           0.5           0.5      0  0.05  power_gs
      602        782           0.5           0.5      0  0.05  power_gs
      603        782           0.5           0.5      0  0.05  power_gs
      604        782           0.5           0.5      0  0.05  power_gs
      605        782           0.5           0.5      0  0.05  power_gs
      606        782           0.5           0.5      0  0.05  power_gs
      607        782           0.5           0.5      0  0.05  power_gs
      608        782           0.5           0.5      0  0.05  power_gs
      609        782           0.5           0.5      0  0.05  power_gs
      610        782           0.5           0.5      0  0.05  power_gs
      611        782           0.5           0.5      0  0.05  power_gs
      612        782           0.5           0.5      0  0.05  power_gs
      613        782           0.5           0.5      0  0.05  power_gs
      614        782           0.5           0.5      0  0.05  power_gs
      615        782           0.5           0.5      0  0.05  power_gs
      616        782           0.5           0.5      0  0.05  power_gs
      617        782           0.5           0.5      0  0.05  power_gs
      618        782           0.5           0.5      0  0.05  power_gs
      619        782           0.5           0.5      0  0.05  power_gs
      620        782           0.5           0.5      0  0.05  power_gs
      621        782           0.5           0.5      0  0.05  power_gs
      622        782           0.5           0.5      0  0.05  power_gs
      623        782           0.5           0.5      0  0.05  power_gs
      624        782           0.5           0.5      0  0.05  power_gs
      625        782           0.5           0.5      0  0.05  power_gs
      626        782           0.5           0.5      0  0.05  power_gs
      627        782           0.5           0.5      0  0.05  power_gs
      628        782           0.5           0.5      0  0.05  power_gs
      629        782           0.5           0.5      0  0.05  power_gs
      630        782           0.5           0.5      0  0.05  power_gs
      631        782           0.5           0.5      0  0.05  power_gs
      632        782           0.5           0.5      0  0.05  power_gs
      633        782           0.5           0.5      0  0.05  power_gs
      634        782           0.5           0.5      0  0.05  power_gs
      635        782           0.5           0.5      0  0.05  power_gs
      636        782           0.5           0.5      0  0.05  power_gs
      637        782           0.5           0.5      0  0.05  power_gs
      638        782           0.5           0.5      0  0.05  power_gs
      639        782           0.5           0.5      0  0.05  power_gs
      640        782           0.5           0.5      0  0.05  power_gs
      641        782           0.5           0.5      0  0.05  power_gs
      642        782           0.5           0.5      0  0.05  power_gs
      643        782           0.5           0.5      0  0.05  power_gs
      644        782           0.5           0.5      0  0.05  power_gs
      645        782           0.5           0.5      0  0.05  power_gs
      646        782           0.5           0.5      0  0.05  power_gs
      647        782           0.5           0.5      0  0.05  power_gs
      648        782           0.5           0.5      0  0.05  power_gs
      649        782           0.5           0.5      0  0.05  power_gs
      650        782           0.5           0.5      0  0.05  power_gs
      651        782           0.5           0.5      0  0.05  power_gs
      652        782           0.5           0.5      0  0.05  power_gs
      653        782           0.5           0.5      0  0.05  power_gs
      654        782           0.5           0.5      0  0.05  power_gs
      655        782           0.5           0.5      0  0.05  power_gs
      656        782           0.5           0.5      0  0.05  power_gs
      657        782           0.5           0.5      0  0.05  power_gs
      658        782           0.5           0.5      0  0.05  power_gs
      659        782           0.5           0.5      0  0.05  power_gs
      660        782           0.5           0.5      0  0.05  power_gs
      661        782           0.5           0.5      0  0.05  power_gs
      662        782           0.5           0.5      0  0.05  power_gs
      663        782           0.5           0.5      0  0.05  power_gs
      664        782           0.5           0.5      0  0.05  power_gs
      665        782           0.5           0.5      0  0.05  power_gs
      666        782           0.5           0.5      0  0.05  power_gs
      667        782           0.5           0.5      0  0.05  power_gs
      668        782           0.5           0.5      0  0.05  power_gs
      669        782           0.5           0.5      0  0.05  power_gs
      670        782           0.5           0.5      0  0.05  power_gs
      671        782           0.5           0.5      0  0.05  power_gs
      672        782           0.5           0.5      0  0.05  power_gs
      673        782           0.5           0.5      0  0.05  power_gs
      674        782           0.5           0.5      0  0.05  power_gs
      675        782           0.5           0.5      0  0.05  power_gs
      676        782           0.5           0.5      0  0.05  power_gs
      677        782           0.5           0.5      0  0.05  power_gs
      678        782           0.5           0.5      0  0.05  power_gs
      679        782           0.5           0.5      0  0.05  power_gs
      680        782           0.5           0.5      0  0.05  power_gs
      681        782           0.5           0.5      0  0.05  power_gs
      682        782           0.5           0.5      0  0.05  power_gs
      683        782           0.5           0.5      0  0.05  power_gs
      684        782           0.5           0.5      0  0.05  power_gs
      685        782           0.5           0.5      0  0.05  power_gs
      686        782           0.5           0.5      0  0.05  power_gs
      687        782           0.5           0.5      0  0.05  power_gs
      688        782           0.5           0.5      0  0.05  power_gs
      689        782           0.5           0.5      0  0.05  power_gs
      690        782           0.5           0.5      0  0.05  power_gs
      691        782           0.5           0.5      0  0.05  power_gs
      692        782           0.5           0.5      0  0.05  power_gs
      693        782           0.5           0.5      0  0.05  power_gs
      694        782           0.5           0.5      0  0.05  power_gs
      695        782           0.5           0.5      0  0.05  power_gs
      696        782           0.5           0.5      0  0.05  power_gs
      697        782           0.5           0.5      0  0.05  power_gs
      698        782           0.5           0.5      0  0.05  power_gs
      699        782           0.5           0.5      0  0.05  power_gs
      700        782           0.5           0.5      0  0.05  power_gs
      701        782           0.5           0.5      0  0.05  power_gs
      702        782           0.5           0.5      0  0.05  power_gs
      703        782           0.5           0.5      0  0.05  power_gs
      704        782           0.5           0.5      0  0.05  power_gs
      705        782           0.5           0.5      0  0.05  power_gs
      706        782           0.5           0.5      0  0.05  power_gs
      707        782           0.5           0.5      0  0.05  power_gs
      708        782           0.5           0.5      0  0.05  power_gs
      709        782           0.5           0.5      0  0.05  power_gs
      710        782           0.5           0.5      0  0.05  power_gs
      711        782           0.5           0.5      0  0.05  power_gs
      712        782           0.5           0.5      0  0.05  power_gs
      713        782           0.5           0.5      0  0.05  power_gs
      714        782           0.5           0.5      0  0.05  power_gs
      715        782           0.5           0.5      0  0.05  power_gs
      716        782           0.5           0.5      0  0.05  power_gs
      717        782           0.5           0.5      0  0.05  power_gs
      718        782           0.5           0.5      0  0.05  power_gs
      719        782           0.5           0.5      0  0.05  power_gs
      720        782           0.5           0.5      0  0.05  power_gs
      721        782           0.5           0.5      0  0.05  power_gs
      722        782           0.5           0.5      0  0.05  power_gs
      723        782           0.5           0.5      0  0.05  power_gs
      724        782           0.5           0.5      0  0.05  power_gs
      725        782           0.5           0.5      0  0.05  power_gs
      726        782           0.5           0.5      0  0.05  power_gs
      727        782           0.5           0.5      0  0.05  power_gs
      728        782           0.5           0.5      0  0.05  power_gs
      729        782           0.5           0.5      0  0.05  power_gs
      730        782           0.5           0.5      0  0.05  power_gs
      731        782           0.5           0.5      0  0.05  power_gs
      732        782           0.5           0.5      0  0.05  power_gs
      733        782           0.5           0.5      0  0.05  power_gs
      734        782           0.5           0.5      0  0.05  power_gs
      735        782           0.5           0.5      0  0.05  power_gs
      736        782           0.5           0.5      0  0.05  power_gs
      737        782           0.5           0.5      0  0.05  power_gs
      738        782           0.5           0.5      0  0.05  power_gs
      739        782           0.5           0.5      0  0.05  power_gs
      740        782           0.5           0.5      0  0.05  power_gs
      741        782           0.5           0.5      0  0.05  power_gs
      742        782           0.5           0.5      0  0.05  power_gs
      743        782           0.5           0.5      0  0.05  power_gs
      744        782           0.5           0.5      0  0.05  power_gs
      745        782           0.5           0.5      0  0.05  power_gs
      746        782           0.5           0.5      0  0.05  power_gs
      747        782           0.5           0.5      0  0.05  power_gs
      748        782           0.5           0.5      0  0.05  power_gs
      749        782           0.5           0.5      0  0.05  power_gs
      750        782           0.5           0.5      0  0.05  power_gs
      751        782           0.5           0.5      0  0.05  power_gs
      752        782           0.5           0.5      0  0.05  power_gs
      753        782           0.5           0.5      0  0.05  power_gs
      754        782           0.5           0.5      0  0.05  power_gs
      755        782           0.5           0.5      0  0.05  power_gs
      756        782           0.5           0.5      0  0.05  power_gs
      757        782           0.5           0.5      0  0.05  power_gs
      758        782           0.5           0.5      0  0.05  power_gs
      759        782           0.5           0.5      0  0.05  power_gs
      760        782           0.5           0.5      0  0.05  power_gs
      761        782           0.5           0.5      0  0.05  power_gs
      762        782           0.5           0.5      0  0.05  power_gs
      763        782           0.5           0.5      0  0.05  power_gs
      764        782           0.5           0.5      0  0.05  power_gs
      765        782           0.5           0.5      0  0.05  power_gs
      766        782           0.5           0.5      0  0.05  power_gs
      767        782           0.5           0.5      0  0.05  power_gs
      768        782           0.5           0.5      0  0.05  power_gs
      769        782           0.5           0.5      0  0.05  power_gs
      770        782           0.5           0.5      0  0.05  power_gs
      771        782           0.5           0.5      0  0.05  power_gs
      772        782           0.5           0.5      0  0.05  power_gs
      773        782           0.5           0.5      0  0.05  power_gs
      774        782           0.5           0.5      0  0.05  power_gs
      775        782           0.5           0.5      0  0.05  power_gs
      776        782           0.5           0.5      0  0.05  power_gs
      777        782           0.5           0.5      0  0.05  power_gs
      778        782           0.5           0.5      0  0.05  power_gs
      779        782           0.5           0.5      0  0.05  power_gs
      780        782           0.5           0.5      0  0.05  power_gs
      781        782           0.5           0.5      0  0.05  power_gs
      782        782           0.5           0.5      0  0.05  power_gs

