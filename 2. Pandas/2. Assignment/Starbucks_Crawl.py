# 전국 스타벅스 매장 정보 불러오는 코드
#--- 최종 ND-python-7-assignment.ipynb


import pandas as pd
import numpy as np
import requests

# 사용할 url들
# url = "https://www.starbucks.co.kr/store/getStore.do?r=0TB85BHU56"
# referer = "https://www.starbucks.co.kr/store/store_map.do?disp=quick"
# params = "in_biz_cds=0&in_scodes=0&ins_lat=37.368665899999996&ins_lng=127.11512619999999&search_text=&p_sido_cd=01&p_gugun_cd=&isError=true&in_distance=0&in_biz_cd=&iend=1000&searchType=C&set_date=&rndCod=3WBZBCPSZ8&all_store=0&T03=0&T01=0&T12=0&T09=0&T30=0&T05=0&T22=0&T21=0&T10=0&T36=0&P10=0&P50=0&P20=0&P60=0&P30=0&P70=0&P40=0&P80=0&whcroad_yn=0&P90=0&new_bool=0"

# 전체 열, 컬럼 등을 보고싶다면 사용하는 함수
# pd.set_option('display.max_seq_items', None)
# pd.set_option('display.max_rows', None)
# pd.set_option('display.max_columns', None)


# -- 함수 만들기
def get_store_with_sido_num(sido_num):
    st_by_sido = []
    url = "https://www.starbucks.co.kr/store/getStore.do?r=0TB85BHU56"
    response = requests.post(url, params = f"in_biz_cds=0&in_scodes=0&ins_lat=37.566926455583385&ins_lng=126.97212112504282&search_text=&p_sido_cd={sido_num}&p_gugun_cd=&isError=true&in_distance=0&in_biz_cd=&iend=1000&searchType=C&set_date=&rndCod=3WBZBCPSZ8&all_store=0&T03=0&T01=0&T12=0&T09=0&T30=0&T05=0&T22=0&T21=0&T10=0&T36=0&P10=0&P50=0&P20=0&P60=0&P30=0&P70=0&P40=0&P80=0&whcroad_yn=0&P90=0&new_bool=0")
    sb_df = pd.DataFrame(response.json()["list"])
    stores = sb_df[["sido_name","gugun_name","s_name","addr","tel","s_code","gugun_code"]]
    st_by_sido.append(stores)
    df = pd.concat(st_by_sido)
    return df

# -- 시도 코드 리스트 받아오기
url = "https://www.starbucks.co.kr/store/getSidoList.do"
response = requests.post(url, params = f"in_biz_cds=0&in_scodes=0&ins_lat=37.566926455583385&ins_lng=126.97212112504282&search_text=&p_sido_cd=01&p_gugun_cd=&isError=true&in_distance=0&in_biz_cd=&iend=1000&searchType=C&set_date=&rndCod=3WBZBCPSZ8&all_store=0&T03=0&T01=0&T12=0&T09=0&T30=0&T05=0&T22=0&T21=0&T10=0&T36=0&P10=0&P50=0&P20=0&P60=0&P30=0&P70=0&P40=0&P80=0&whcroad_yn=0&P90=0&new_bool=0")
sido_list = pd.DataFrame(response.json()["list"])
sido_num = sido_list["sido_cd"].to_list()
# sido_num

# -- for 문으로 반복 돌리기
please_add_here = []
for num in sido_num:
    s_list = pd.DataFrame(get_store_with_sido_num(num))
    please_add_here.append(s_list)
    all_store = pd.concat(please_add_here)

# all_store

# -- 데이터 값 수정하기

# 개수 확인
# len(all_store['sido_name'].unique()) == len(sido_num)
# False 출력된다.

# 'sido_name' 고유값 개수 확인하기
# all_store['sido_name'].value_counts()

# '강원도'를 '강원'로 문자 대체하기
# 방법1. replace() 사용
all_store['sido_name'] = all_store['sido_name'].replace('강원도','강원')

# 방법2. apply(lambda ) 사용
all_store['sido_name'] = all_store['sido_name'].apply(lambda x : '강원' if x == '강원도' else x)


# 결과
pd.set_option('display.max_rows', None)
# all_store

# 인덱스 정리하기
all_store.reset_index(drop=True, inplace=True)
all_store
