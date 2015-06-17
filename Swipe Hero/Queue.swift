//
//  Queue.swift
//  Swipe Hero
//
//  Created by Ricardo Z Charf on 6/17/15.
//  Copyright (c) 2015 Caio. All rights reserved.
//

import UIKit

class Queue<T>
{
    private var head:Node<T>? = nil;
    private var tail:Node<T>? = nil;
    var length = 0;
    
    init()
    {
        
    }
    
    func push(object:T)
    {
        if(self.head == nil)
        {
            var head:Node<T> = Node<T>(object: object);
            self.head = head;
            self.tail = head;
        }else
        {
            var newNode:Node<T> = Node<T>(object: object);
            self.tail!.next = newNode;
            self.tail = newNode;
        }
        self.length++;
    }
    
    func pop() -> T?
    {
        if(self.head != nil)
        {
            var object:T = self.head!.value;
            self.head = self.head!.next;
            self.length--;
            return object;
        }
        return nil;
    }
    
    func getPosition(i:Int)->T?
    {
        var j:Int;
        var node:Node<T>?
        node = self.head;
        if(self.length==0)
        {
            return nil;
        }
        for(j=0;j<i;j++)
        {
            if(node?.next == nil )
            {
                return nil;
            }
            node = node!.next;
        }
        return node!.value;
    }
    
    func emptyQueue()
    {
        self.head = nil;
        self.tail = nil;
        self.length = 0;
    }
    
}

class Node<T>
{
    var next:Node<T>? = nil;
    var value:T;
    
    init(object:T)
    {
        self.value = object;
    }
}
