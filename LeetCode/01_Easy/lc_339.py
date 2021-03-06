# 339 - Nested List Weight Sum (Easy)
# https://leetcode.com/problems/nested-list-weight-sum/

# """
# This is the interface that allows for creating nested lists.
# You should not implement it, or speculate about its implementation
# """
#class NestedInteger(object):
#    def isInteger(self):
#        """
#        @return True if this NestedInteger holds a single integer, rather than a nested list.
#        :rtype bool
#        """
#
#    def getInteger(self):
#        """
#        @return the single integer that this NestedInteger holds, if it holds a single integer
#        Return None if this NestedInteger holds a nested list
#        :rtype int
#        """
#
#    def getList(self):
#        """
#        @return the nested list that this NestedInteger holds, if it holds a nested list
#        Return None if this NestedInteger holds a single integer
#        :rtype List[NestedInteger]
#        """

class Solution(object):
    # Do a DFS and multiply each value with the depth at that point.
    def dfs(self, nestedList, depth):
        if len(nestedList) == 0:
            return 0
        acum = 0
        for NI in nestedList:
            if NI.isInteger():
                acum += NI.getInteger() * depth
            else:
                acum += self.dfs(NI.getList(), depth+1)
        return acum
        
    def depthSum(self, nestedList):
        """
        :type nestedList: List[NestedInteger]
        :rtype: int
        """
        return self.dfs(nestedList, 1)
        
        