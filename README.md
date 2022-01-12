# Pets Fighting Club Contracts

** The first purely on-chain game, enjoy it. **

## 合约设计

**具体数值仅供参考**

### 基础宠物: 5 个

### 图片展示:

按照 typeId 展示 (rather than tokenId)

baseURI = {ownLink}

tokenURI = {ownLink}/{typeId}

(ownLink comes from ipfs)

### 宠物 NFT 组成

-- 基础属性

-- 所有装备(NFT)

-- 等级

tip: 每人只能拥有一个基础宠物 可 mint 可 burn

### 打斗系统

### PVE

--训练 trainFight(tokenId)

### PVP

--基础 pvpFight(tokenIdA, tokenIdB)

--匹配 matchFight

--排位 rankFight 

--擂台 roundFight  

--决斗 deathFight
