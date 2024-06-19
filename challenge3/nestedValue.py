def nestval(obj: dict, key: str): # dictionary and key 
    keys = key.split('/') # list of keys created here 
    for k in keys:
        if isinstance(obj, dict) and k in obj:
            obj = obj[k]
        else:
            return None
    return obj

if __name__ == '__main__':
    obj1 = {'a': {'b': {'c': 'd'}}}
    key1 = 'a/b/c'
    print(nestval(obj1, key1))  # we get Output of  d here

    obj2 = {'x': {'y': {'z': 'a'}}}
    key2 = 'x/y/z'
    print(nestval(obj2, key2))  # we get Output a here 
